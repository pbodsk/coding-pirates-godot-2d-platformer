# Godot 2D Platformer - level 15, time...to die
(ja, det var så et citat fra den gamle Science Fiction klassiker [Blade Runner](https://www.imdb.com/title/tt0083658/), den kan du lige skrive på listen)

Efter [level 14](../lesson14/) har vi nu en `Player` der kan sige Av! når den bliver ramt af skud...det kan vi godt gøre bedre og den gode nyhed er at vi har alle byggeklodserne allerede så vi skal ikke opfinde nyt i denne level!

## Hvad vil vi gerne?
Vi har jo allerede bygget en `HealthComponent` så vi skal have tilføjet sådan en på vores `Player`.

Så skal vi gøre næsten det samme som vi gjorde med vores `Walker` i [level 12](../lesson12/).

Og med den smule er vi vist faktisk klar til at gå i gang, lad os lave en liste så vi kan holde styr på hvor langt vi er nået:

- [ ] Tilføj `HealthComponent` til `Player`
- [ ] Tilføj "Die" animation til `Player`
- [ ] Lav `die` funktion på `Player`

Og så til tasterne!

## Tilføj `HealthComponent` til `Player`
Du har gjort det mange gange før, det eneste nye er måske at vi gerne vil give vores `Player` 5 som `max_health` (`Walker` havde 3), så det skal vi lige tilføje i `_ready`
 på vores `player.gd` script.
 
 Prøv selv :)

 Her er vores `player.gd` script efter at vi har tilføjet `health_component`:

 ```gdscript
extends CharacterBody2D

@export_subgroup("Nodes")
@export var animation_component: AnimationComponent
@export var gravity_component: GravityComponent
@export var health_component: HealthComponent
@export var horizontal_movement_component: HorizontalMovementComponent
@export var input_component: InputComponent
@export var jump_component: JumpComponent
@export var shoot_component: ShootComponent

func _ready() -> void:
	health_component.max_health = 5
	add_to_group("Player")
	
func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self, delta)
	horizontal_movement_component.handle_horizontal_movement(self, input_component.horizontal_direction)
	jump_component.handle_jump(self, input_component.jump_was_pressed())
	move_and_slide()
	
func _process(delta: float) -> void:
	animation_component.handle_move_animation(input_component.horizontal_direction)
	animation_component.handle_jump_animation(gravity_component.is_jumping, gravity_component.is_falling)
	
	if input_component.shoot_was_pressed():
		var direction = Vector2.LEFT if animation_component.get_sprite_direction() == -1 else Vector2.RIGHT
		shoot_component.handle_shoot_requested(position, direction, Vector2(16, 0), "Enemy")

func hit(damage: int) -> void:
	health_component.hit(damage)
 ```

 Det var step 1

- [X] Tilføj `HealthComponent` til `Player`
- [ ] Tilføj "Die" animation til `Player`
- [ ] Lav `die` funktion på `Player`

Videre til animation!

## Tilføj "Die" animation til `Player`
Ganske som på vores `Walker` skal vi også have en "Die" animation på vores `Player` for det forventer `AnimationComponent` jo at der er når man dør.

Du kan finde sprite sheetet "space-marine-die.png" i assets mappen som du kan bruge til animationen.

 Det var step 2

- [X] Tilføj `HealthComponent` til `Player`
- [X] Tilføj "Die" animation til `Player`
- [ ] Lav `die` funktion på `Player`

## Lav `die` funktion på `Player`
Logikken her ligner meget den vi havde i `walker.gd`, forskellen er bare at vi ikke vil kalde `queue_free()`, senere vil vi lave en game over skærm i stedet.

Se om du selv kan regne logkken ud ved at stjæle og rette til fra `walker.gd`, her er vores forsøg:

```gdscript
extends CharacterBody2D

@export_subgroup("Nodes")
@export var animation_component: AnimationComponent
@export var gravity_component: GravityComponent
@export var health_component: HealthComponent
@export var horizontal_movement_component: HorizontalMovementComponent
@export var input_component: InputComponent
@export var jump_component: JumpComponent
@export var shoot_component: ShootComponent

var is_dying: bool = false

func _ready() -> void:
	health_component.max_health = 5
	is_dying = false
	add_to_group("Player")
	
func _physics_process(delta: float) -> void:		
	gravity_component.handle_gravity(self, delta)
	horizontal_movement_component.handle_horizontal_movement(self, input_component.horizontal_direction)
	jump_component.handle_jump(self, input_component.jump_was_pressed())
	move_and_slide()
	
func _process(delta: float) -> void:
	# er vi ved at dø, så bare stop her
	if is_dying:
		return
		
	# Kun hvis vi okke er døde kommer vi videre her til
	# Er vi så døde i mellemtiden?
	if health_component.is_dead():
		# Ja det var vi, så kald die funktionen der
		# sørger for at vi dør pænt :)
		await die()
	else:
		animation_component.handle_move_animation(input_component.horizontal_direction)
		animation_component.handle_jump_animation(gravity_component.is_jumping, gravity_component.is_falling)
	
		if input_component.shoot_was_pressed():
			var direction = Vector2.LEFT if animation_component.get_sprite_direction() == -1 else Vector2.RIGHT
			shoot_component.handle_shoot_requested(position, direction, Vector2(16, 0), "Enemy")

func hit(damage: int) -> void:
	health_component.hit(damage)
	
func die() -> void:
	# flip is_dying så vi ikke ryger i _process igen
	is_dying = true
	
	# gør så player kan løbe igennem animationen
	set_physics_process(false)
	
	# vent på at die animationen spiller færdig
	await animation_component.handle_die_animation()
```

Og det var step 3

- [X] Tilføj `HealthComponent` til `Player`
- [X] Tilføj "Die" animation til `Player`
- [X] Lav `die` funktion på `Player`

Kør nu dit spil og prøv...du skulle nu gerne blive pløkke nådesløst af vores `Walker` når den opdager dig.

Måske er spillet lidt for svært. Så kan du skrue ned for antal skud i en salve eller skrue op for health på vores `Player`, du kender alle delene nu :)

## Det var det
Dejligt med en lille nem level for en gangs skyld! I [næste level](../lesson16/) vil vi forsøge os med at lave en health bar for vores `Player` så vi kan se hvor meget energi vi har. Vi ses.