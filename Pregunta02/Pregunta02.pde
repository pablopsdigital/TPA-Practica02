/**
 * Pregunta 02
 * Pablo Pérez Sineiro
 * 26/03/2021
 *
 * =======================================================================================================
 * ENUNCIADO PREGUNTA 2:
 * =======================================================================================================
 * En esta pregunta desarrollaremos una aplicación que permita ver y escuchar la diferencia entre cuatro 
 * tipos de onda: senoidal, triangular, diente de sierra y cuadrada. El análisis espectral mostrará, para
 * cada tipo de onda, la distribución de la frecuencia fundamental y armónicos. Finalmente aplicaremos un
 * filtro paso-bajos donde se podrá comprobar cómo afecta éste a la forma de las ondas y su espectro. 
 *
 * Para implementar la solución daremos cumplimiento a los siguientes puntos en una ventana de la aplicación
 * de 512x500 píxeles y Processing 3D:
 * 
 *   01.Generar una onda sinusoidal de frecuencia 1200hz y amplitud 0.5 que luego podrá ser
 modificada en forma, frecuencia y amplitud.
 *   02.Enviar el sonido generado (objeto Patch) a la salida de la tarjeta de sonido.
 *   03.Dibujar la forma de onda mostrando el canal izquierdo arriba y el canal derecho justo debajo dejando
 *      la mitad inferior de la ventana por el espectro y el texto.
 *   04.El movimiento horizontal del ratón debe controlar la frecuencia variando entre 110 y 2400Hz
 *   05.El movimiento vertical del ratón debe controlar la amplitud que variará entre 0 y 1.
 *   06.Mostrar, en el lugar más adecuado para su lectura, el valor de frecuencia y amplitud aunque el ratón
 *      no se encuentre dentro de la ventana, sugerimos derecha inferior.
 *   07.Permitir el cambio de tipo de onda y frecuencia con las siguientes teclas:
 *    a. Tecla '1': onda Sinusoïdal
 *    b. Tecla '2': onda Triangular
 *    c. Tecla '3': onda Diente de sierra
 *    d. Tecla '4': onda Cuadrada
 *    e. Tecla '+': + 1 Hz
 *    f. Tecla '-': - 1 Hz
 *   08.A través del objeto FFT con valor de tiempo 1024 y frecuencia 44100, realizar un análisis espectral
 *      que debe mostrarse en rojo.
 *   09.Aplicar un filtro pasa bajos con una frecuencia de corte a 1200Hz y resonancia de 0.5
 *   10.Permitir que la tecla 'de el desactive y activarla en la salida.
 * 
 * =======================================================================================================
 * DESCRIPCIÓN:
 * =======================================================================================================
 *
 *
 *
 */

//========================================================================================================
//Importación de paquetes necesarios
//========================================================================================================
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*;
import ddf.minim.analysis.*;


//Definimos los objetos
Minim minim;
Oscil wave;
FFT fft;
AudioOutput out;
MoogFilter moogFilter;
boolean moogFilterIsActive;
private PFont font;


//========================================================================================================
//Función de inicialización
//========================================================================================================
void setup() {

  size(512, 500, P3D);
  font = createFont("Poppins-Regular.ttf", 13);
  textFont(font);

  //Crear motor minim
  minim = new Minim(this);

  //Crear onda
  wave = new Oscil(1200.0, 0.5f, Waves.SINE);


  // Construimos el objeto fft
  fft = new FFT(1024, 44100);

  //Creación filtro paso bajo "MoogFilter.Type,LP" a traves de un filtro moog
  moogFilter = new MoogFilter(1200, 0.5, MoogFilter.Type.LP);

  //Inicializar AudioOutput
  out = minim.getLineOut();

  //Enviar a la salida
  wave.patch(out);
  wave.patch(moogFilter);
  moogFilter.patch(out);
}


//========================================================================================================
//Bucle principal
//========================================================================================================
void draw() {

  background(0);
  stroke(255, 255, 0);
  strokeWeight(1);

  // Dibujamos la forma de onda en la ventana de la aplicación
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    line(i, 50 - out.left.get(i)*50, i+1, 50 - out.left.get(i+1)*50);
    line(i, 150 - out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50);
  }


  //Añadir textos
  textAlign(LEFT);
  text("Valor Frecuencia: " + wave.frequency.getLastValue() + " Hz", width-250, height-40);
  text("Valor Amplitud: " + wave.amplitude.getLastValue(), width-250, height-20);


  //Añadir objte FFT para el análisis espectral
  fft.forward(out.mix);

  // Dibujamos el espectro en la ventana de la aplicación
  // Multiplicamos el valor del análisis (getBand) por 8 para visualizar mejor el espectro
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    // Espectro en rojo
    stroke(255, 0, 0);
    line(i, height, i, height - fft.getBand(i)*8);
  }
}

//========================================================================================================
//Función detectar movimientos del ratón
//========================================================================================================
void mouseMoved() {

  //En el eje vertical(Y) se modifica la amplitu
  float amplitudeMouse = map(mouseY, 0, height, 1, 0);
  wave.setAmplitude(amplitudeMouse);

  //En el eje horizontal(X) se modifica la frecuencia
  float frequencyMouse = map(mouseX, 0, width, 110.0, 2000.0);
  wave.setFrequency(frequencyMouse);
}

//========================================================================================================
//Función presionar teclas
//========================================================================================================
void keyPressed() {
  switch(key)
  {

  case '1'://Onda Sinusoidal
    wave.setWaveform( Waves.SINE );
    break;

  case '2'://Onda Triangular
    wave.setWaveform( Waves.TRIANGLE );
    break;

  case '3'://Onda Diente de sierra
    wave.setWaveform( Waves.SAW );
    break;

  case '4'://Onda cuadra
    wave.setWaveform( Waves.SQUARE );
    break;

  case '+'://+1Hz
    wave.setFrequency( wave.frequency.getLastValue()+1 );
    break;

  case '-'://-1Hz
    wave.setFrequency( wave.frequency.getLastValue()-1 );
    break;

  case 'd'://Activar-Desactivar la salida filtro moog
    if ( moogFilterIsActive==true) {
      moogFilter.unpatch(out);
      moogFilterIsActive=false;
    } else {
      moogFilter.patch(out);
      moogFilterIsActive=true;
    }
    break;

  default:
    break;
  }
}
