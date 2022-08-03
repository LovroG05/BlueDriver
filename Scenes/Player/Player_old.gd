extends KinematicBody
# Car behavior parameters, adjust as needed
export var gravity = -20.0
export var wheel_base = 0.6  # distance between front/rear axles
export var steering_limit = 10.0  # front wheel max turning angle (deg)
export var engine_power = 6.0
export var braking = -9.0
export var friction = -2.0
export var drag = -2.0
export var max_speed_reverse = 3.0

# Car state properties
var acceleration = Vector3.ZERO  # current acceleration
var velocity = Vector3.ZERO  # current velocity
var steer_angle = 0.0  # current wheel angle

export var slip_speed = 15.0
export var traction_slow = 0.75
export var traction_fast = 0.02

var nosteer = true

export var drifting = false



func _physics_process(delta):
	if is_on_floor():
		get_input()
		apply_friction(delta)
		calculate_steering(delta)

	acceleration.y = gravity
	velocity += acceleration * delta
	velocity = move_and_slide_with_snap(velocity, -transform.basis.y, Vector3.UP)

		
	
	if drifting:
		$Particles2.emitting = true
		$Particles3.emitting = true
	else:
		$Particles2.emitting = false
		$Particles3.emitting = false
		

func apply_friction(delta):
	if velocity.length() < 0.2 and acceleration.length() == 0:
		velocity.x = 0
		velocity.z = 0
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force

func calculate_steering(delta):
	var rear_wheel = transform.origin + transform.basis.z * wheel_base / 2.0
	var front_wheel = transform.origin - transform.basis.z * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(transform.basis.y.normalized(), steer_angle) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)
	
		# traction
	if not drifting and velocity.length() > slip_speed:
		drifting = true
	if drifting and velocity.length() < slip_speed and steer_angle == 0:
		drifting = false
	var traction = traction_fast if drifting else traction_slow

	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	look_at(transform.origin + new_heading, transform.basis.y)
	

	
func get_input():
	var turn = Input.get_action_strength("steer_left")
	turn -= Input.get_action_strength("steer_right")
	steer_angle = turn * deg2rad(steering_limit)
	if turn != 0:
		nosteer = false
	var mock_steer = steer_angle
	if drifting:
		mock_steer = -mock_steer
	$sedanSports/wheel_frontRight.rotation.y = mock_steer*2
	$sedanSports/wheel_frontLeft.rotation.y = mock_steer*2
	acceleration = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		acceleration = -transform.basis.z * engine_power
		
	if Input.is_action_pressed("reverse"):
		acceleration = -transform.basis.z * braking
		$sedanSports/RL.light_specular = 0.8
		$sedanSports/RL.light_energy = 16
		$sedanSports/RL2.light_energy = 16
		$sedanSports/RL2.light_specular = 0.8
	else:
		$sedanSports/RL.light_specular = 0.5
		$sedanSports/RL.light_energy = 9
		$sedanSports/RL2.light_energy = 9
		$sedanSports/RL2.light_specular = 0.5
		
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

