/**
 * Pregunta 02
 * Pablo Pérez Sineiro
 * 26/03/2021
 *
 * =======================================================================================================
 * ENUNCIADO PREGUNTA 2:
 * =======================================================================================================
 * En esta pregunta desarrollaremos una aplicación que permita ver y escuchar la d iferencia entre cuatro 
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
 * DESCRIPCIÓN ESTRUCTURA GENERAL DEL CÓDIGO:
 * =======================================================================================================
 * Siguiendo los ejemplos presentados en la unidad, para la realización del siguiente ejercicio se ha
 * estructurado el código de la siguiente manera:
 * 
 * 1- Importar los paquetes necesarios, definición de variables y configuración general de la ventana.
 * 2- Inicialización del motor minim así como la creación del oscilador para la onda a representar.
 * 3- Creación de objeto FFT (Transformada de Fourier) para analizar la frecuencia de la onda.
 * 4- Creación del filtro Moog que se utiliza en este caso para añadir el paso bajo.
 * 5- Se crea la conexión del filtro y la conexión de la salida con el filtro aplicado.
 * 6- Finalmente se conecta cada canal a la salida a través de un objeto patch.
 * 7- Se dibujan las ondas de los dos canales.
 * 8- Se dibuja el espectograma.
 * 9- El resto del código está orientado a crear las condiciones en caso de mover el ratón o de pulsar alguna de
 *    las teclas asignadas de forma que se modifiquen los parametros indicados en el enumciado.
 *
 * NOTA: En cada línea se especifica con mayor claridad la funcionalidad de cada apartado del código.
 *
 */

//========================================================================================================
//Importación de paquetes necesarios
//========================================================================================================
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*;
import ddf.minim.analysis.*;


//========================================================================================================
//Definición de variables
//========================================================================================================
Minim minim;//Objeto minim
Oscil wave; //Oscilador para la onda
FFT fft; //Transformada de Fourier para analizar el audio
AudioOutput out; // Objeto para la salida de audio
MoogFilter moogFilter; //Creación del filtro para añadir un paso bajo/alto
boolean moogFilterIsActive;//Variable de apoyo para definir si el filtro esta activo
private PFont font;//Variable para definir la fuente de la interfaz


//========================================================================================================
//Función de inicialización
//========================================================================================================
void setup() {

  //Espeficiación de los parametros de la ventana, con Processing 3D
  size(512, 500, P3D);
  font = createFont("Poppins-Regular.ttf", 13);//Tipografía
  textFont(font);//Asignación de la tipografía

  //Se inicializa el motor Minim
  minim = new Minim(this);

  // Inicialización del oscilador (frecuencia, amplitud, tipo onda senoidal)
  wave = new Oscil(1200.0, 0.5f, Waves.SINE);

  // Se inicializa el objeto fft para el analisis espectral
  fft = new FFT(1024, 44100);

  //Se crea el filtro paso bajo "MoogFilter.Type,LP" a traves de un filtro moog
  //(frecuencia, resonancia, tipo de filtro LP - paso baj, LP - paso alto)
  moogFilter = new MoogFilter(1200, 0.5, MoogFilter.Type.LP);

  //Inicialización salida audio (AudioOutput)
  out = minim.getLineOut();

  //Se conectan todo a la salida, se inicia con el filtro paso bajo activo
  //Oscilador-Filtro-Salida
  wave.patch(moogFilter).patch(out);
  
  //Variable de filtro activo a true
  moogFilterIsActive=true;
}


//========================================================================================================
//Bucle principal
//========================================================================================================
void draw() {

  //Color de fondo y color y grosor de las lineas
  background(0);
  stroke(255, 255, 0);
  strokeWeight(1);

  //Se dibujan las formas de las ondas
  //Por cada bit del buffer de la salida
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    //Por cada bit del buffer se dibuja un punto de la linea de cada onda estableciendo las coordenadas de la ventana
    line(i, 50 - out.left.get(i)*50, i+1, 50 - out.left.get(i+1)*50);
    line(i, 150 - out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50);
  }


  //Se crea el texto y datos que aparecen en la interfaz
  textAlign(LEFT);
  text("Valor Frecuencia: " + wave.frequency.getLastValue() + " Hz", width-350, height-40);
  text("Valor Amplitud: " + wave.amplitude.getLastValue(), width-350, height-20);
  
  //Añador textos de información y ayuda adicional
  text("Cambiar tipo onda con teclas: 1,2,3,4", width-350, height-80);
  text("Con las teclas + y - podrás modificar la frecuencia", width-350, height-100);
  text("Ratón en horizontal: frecuencia", width-350, height-120);
  text("Ratón en vertical: amplitud", width-350, height-140);
  text("Filtro paso bajo: " + ((moogFilterIsActive==true)?"CONECTADO":"DESCONECTADO"), width-350, height-160);


  //Se añade el objeto FFT para el análisis espectral de ambos canales
  fft.forward(out.mix);

  // Dibujamos el espectro en la ventana de la aplicación analizando cada bit del buffer de salida
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    // Espectro en rojo
    stroke(255, 0, 0);
    // Multiplicamos el valor del análisis (getBand) por 8 para visualizar mejor el espectro
    line(i, height, i, height - fft.getBand(i)*8);
  }
}

//========================================================================================================
//Función detectar movimientos del ratón
//========================================================================================================
void mouseMoved() {

  //En el eje vertical(Y) se modifica la amplitud entre un rango de valores determinado 0-1
  //Se emplea el método map() de processing para controlar el rango de valores
  //map(value, start1, stop1, start2, stop2)
  float amplitudeMouse = map(mouseY, 0, height, 1, 0);
  wave.setAmplitude(amplitudeMouse);

  //En el eje horizontal(X) se modifica la frecuencia entre un rango de valores determinado 110-2400
  float frequencyMouse = map(mouseX, 0, width, 110.0, 2400.0);
  wave.setFrequency(frequencyMouse);
}

//========================================================================================================
//Función presionar teclas
//========================================================================================================
void keyPressed() {

  // Cada vez que se pulse una tecla se ejecuta esta función
  // Si se pulsa una tecla entre 1 y 4 se ejecuta este código y se cambia el tipo de onda aplicada al oscilador
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
    //Al pulsar la tecla + se incrementa 1Hz la frecuencia de la ondas
    wave.setFrequency( wave.frequency.getLastValue()+1 );
    break;

  case '-'://-1Hz
    //Al pulsar la tecla - se baja 1Hz la frecuencia de la ondas
    wave.setFrequency( wave.frequency.getLastValue()-1 );
    break;

  case 'd':
    //Activar-Desactivar la salida filtro moog
    if ( moogFilterIsActive==true) {
      //Se desconecta el filtro
      wave.unpatch(moogFilter);
      wave.patch(out);
      moogFilterIsActive=false;
    } else {
      //Se conecta el filtro nuevamente
      wave.unpatch(out);
      wave.patch(moogFilter);
      moogFilterIsActive=true;
    }
    break;

  default:
    break;
  }
}
