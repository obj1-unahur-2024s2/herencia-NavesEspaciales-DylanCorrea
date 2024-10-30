class Nave{
    var  velocidad
    var  direccion
    var combustible

    method acelerar(cuanto) { velocidad = 100000.min(velocidad + cuanto)}
    method desacelerar(cuanto){ velocidad = 0.max(velocidad - cuanto)}
    method irHaciaElSol(){direccion = 10}
    method escaparDelSol() {direccion = -10}
    method ponerseParaleloAlSol(){direccion = 0}
    method acercarseUnPocoAlSol() {direccion = 10.min(direccion + 1)}
    method alejarseUnPocoAlSol() {direccion = -10.max(direccion - 1)}
    method combustible() = combustible
    method cargarCombustible(litros) {
      combustible += litros
    }
    method descargarCombustible(litros) {
      combustible = 0.max(combustible + litros)
    }
    method prepararViaje() {self.cargarCombustible(30000) self.acelerar(5000) self.condicionAdicional()}
    method condicionAdicional()     
    method estaTranquila() {
      return combustible >= 4000 && velocidad <= 12000
    }
    method recibirAmenaza(){self.escapar() self.avisar()}
    method escapar() 
    method avisar() 
    method estaDeRelajo() = self.estaTranquila() && self.tienePocaActividad()
    method tienePocaActividad()   
}

class NaveBaliza inherits Nave {
  var baliza 
  const coloresValidos = #{"verde","rojo","azul"}
  var cambioDeColor 

  method cambiarColorDeBaliza(colorNuevo) {
    /*if(coloresValidos.contains(colorNuevo))
    baliza = colorNuevo
    else self.error("El color nuevo no es valido")
    Otra manera*/
        if (not coloresValidos.contains(colorNuevo))
            self.error("El color nuevo no es valido")
            
        baliza = colorNuevo
        cambioDeColor = true
  }
  override method condicionAdicional() {
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  override method estaTranquila() {
    return super() && baliza != "rojo"
  }
  override method escapar(){self.irHaciaElSol()}
  override method avisar(){self.cambiarColorDeBaliza("rojo")}
  override method tienePocaActividad() = not cambioDeColor  
  method initialize(){cambioDeColor = false baliza="verde"}
  
}

class NaveDePasajero inherits Nave {
  const pasajeros
  var comida
  var bebida
  var racionesDeComidaServidas = 0

  method cargarComida(cantidad) {
    comida += cantidad
  }
  method descargarComida(cantidad) {
    comida = 0.max(comida-cantidad) racionesDeComidaServidas += cantidad
  }
  method cargarBebida(cantidad) {
    bebida += cantidad
  }
  method descargarBebida(cantidad) {
    bebida = 0.max(bebida - cantidad)
  }
  override method condicionAdicional(){
    self.descargarComida(4*pasajeros)
    self.descargarBebida(6*pasajeros)
    self.acercarseUnPocoAlSol()
  }
  override method escapar(){self.acelerar(velocidad)}
  override method avisar(){self.descargarComida(1*pasajeros) self.descargarBebida(2*pasajeros)} 
  override method tienePocaActividad() = racionesDeComidaServidas < 50

}

class NaveDeCombate inherits Nave {
 var estaInvisible = false
 var misilesDesplegados = false
 const mensajesEmitidos = [] 

 method ponerseVisible() {
   estaInvisible = false
 }
 method ponerseInvisible() {
   estaInvisible = true
 }
 method estaInvisible() = estaInvisible   
 method desplegarMisiles() {
   misilesDesplegados = true
 }
 method replegarMisiles() {
   misilesDesplegados = false
 }
 method misilesDesplegados() = misilesDesplegados 
 method emitirMensaje(mensaje) {
   mensajesEmitidos.add(mensaje)
 }
 method mensajesEmitidos() = mensajesEmitidos
 method primerMensajeEmitido() { if(mensajesEmitidos.isEmpty()) self.error("La lista de mensajes esta vacia")
  return mensajesEmitidos.first()
 }
 method ultimoMensajeEmitido() {if(mensajesEmitidos.isEmpty()) self.error("La lista de mensajes esta vacia")
  return mensajesEmitidos.last()
 }
 method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)
 method esEscueta() = not mensajesEmitidos.any({m => m.length() > 30}) // length para saber los caracteres de un string 
 override method condicionAdicional(){
    self.ponerseVisible()
    self.acelerar(15000)
    self.emitirMensaje("Saliendo en mision")
 }
 override method estaTranquila() {
   return super() && !misilesDesplegados 
 }
 override method escapar(){self.acercarseUnPocoAlSol() self.acercarseUnPocoAlSol()}
 override method avisar(){self.emitirMensaje("Amenaza recibida")}
}
class NaveHospital inherits NaveDePasajero {
  var tienePreparadoQuirofanos = false

  method tienePreparadoQuirofanos() = tienePreparadoQuirofanos
  method prepararQuirofanos(){tienePreparadoQuirofanos = !tienePreparadoQuirofanos} 
  override method estaTranquila() = super() && !tienePreparadoQuirofanos
  override method recibirAmenaza() {super() self.prepararQuirofanos() }
}

class NaveSigilosa inherits NaveDeCombate {
  
    override method estaTranquila() = super() && !self.estaInvisible() 
    override method escapar(){super() self.desplegarMisiles() self.ponerseInvisible()}
}