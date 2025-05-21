extends Node2D

# Variáveis de arquivos para personalizar o clicker
@export var clicker_name: String = "Tapas"
@export_group("Imagens Mouse")
@export_file() var mouse_arrow: String
@export_file() var mouse_pointing: String
@export_file() var mouse_pressed: String
@export_group("Imagens Clicker")
@export_file() var clicker_idle: String
@export_file() var clicker_pressed: String
@export_file() var clicker_hover: String

# Nodes (Conseguir acessar e modificar esses nodes)
@onready var button_clicker: TextureButton = $Interface/ButtonClicker
@onready var auto_clicker_button: Button = %AutoClickerButton
@onready var melhorar_click_button = %MelhorarClickButton
@onready var numero_clickers: Label = $Interface/ButtonClicker/NumeroClickers
@onready var spawn_particles: Marker2D = %SpawnParticles
@onready var auto_clicker_price_label: Label = %AutoClickerPrice
@onready var melhorar_click_price_label: Label = %MelhorarClickPrice
@onready var auto_clicker_timer: Timer = $AutoClicker

# Clicker
@export_category("Clicker")
@export var clicks: int = 0
var value_per_click: int = 1
@export var auto_clicker_cooldown: float = 2

# Melhorar Clicks
@export_category("Melhorar Clicks")
@export var melhorar_click_data: Dictionary = {
	"updates": 0,
	"prices": [20, 80, 140, 200, 350, 600, 1000, 3000]
}
@export_category("Auto Clicker")
@export var auto_clicker_data: Dictionary = {
	"price": 5000
}

func _ready() -> void:
	numero_clickers.text = str(clicks) + " " + clicker_name
	melhorar_click_price_label.text = str(melhorar_click_data.prices[melhorar_click_data.updates]) + " " + clicker_name
	auto_clicker_price_label.text = str(auto_clicker_data.price) + " " + clicker_name
	
	if mouse_arrow:
		Input.set_custom_mouse_cursor(
			load(mouse_arrow),
			Input.CURSOR_ARROW,
			
		)
	
	if mouse_pointing:
		Input.set_custom_mouse_cursor(
			load(mouse_pointing),
			Input.CURSOR_POINTING_HAND
		)
	
	if clicker_idle:
		button_clicker.texture_normal = load(clicker_idle)
	
	if clicker_pressed:
		button_clicker.texture_pressed = load(clicker_pressed)
	
	if clicker_hover:
		button_clicker.texture_hover = load(clicker_hover)


func clicar() -> void:
	clicks += value_per_click
	
	numero_clickers.text = str(clicks) + " " + clicker_name

func auto_clicked() -> void:
	clicar()
	
	auto_clicker_timer.start(auto_clicker_cooldown)


func melhorar_click() -> void:
	var _update = melhorar_click_data.updates
	var _price = melhorar_click_data.prices[_update]
	if clicks >= _price:
		clicks -= _price
		melhorar_click_data.updates += 1
		
		value_per_click += 1
		
		if melhorar_click_data.updates >= melhorar_click_data.prices.size():
			melhorar_click_price_label.text = "MÁXIMO"
			
			melhorar_click_button.disabled = true
		else:
			_update = melhorar_click_data.updates
			_price = melhorar_click_data.prices[_update]
			
			melhorar_click_price_label.text = str(_price) + " " + clicker_name
		
		numero_clickers.text = str(clicks) + " " + clicker_name
		


func comprar_autoclicker():
	if clicks >= auto_clicker_data.price:
		clicks -= auto_clicker_data.price
		auto_clicker_timer.start(auto_clicker_cooldown)
		
		auto_clicker_button.disabled = true
		auto_clicker_price_label.text = "VENDIDO"
		
		numero_clickers.text = str(clicks) + " " + clicker_name
