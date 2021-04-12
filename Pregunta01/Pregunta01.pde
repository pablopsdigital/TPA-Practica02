/**
 * Pregunta 01
 * Pablo Pérez Sineiro
 * 26/03/2021
 *
 * =======================================================================================================
 * ENUNCIADO PREGUNTA 1:
 * =======================================================================================================
 * En esta pregunta desarrollaremos una aplicación que permita experimentar con las interferencias entre ondas.
 * Tal y como se ha explicado en el módulo 1, pueden existir interferencias entre ondas de la misma frecuencia
 * (constructiva o destructiva) o de frecuencias ligeramente distintas (batidos de primer orden). Se propone
 * implementar una aplicación que combine las dos familias de interferencias para una mejor comprensión del
 * concepto. Para ello, se proponen los siguientes pasos:
 *
 *   01.Generar dos ondas senoidales, de amplitud A=0.5 y frecuencia f=440Hz. Una de ellas será fija 
 *      durante todo el ejercicio y la otra podrá cambiar de fase y frecuencia.
 *   02.Enviar cada una de ellas (objeto Patch) al canal de la izquierda y derecha mediante el objeto Pan.
 *   03.Enviar la salida de cada onda panoramizada (objeto Patch) a la salida de la tarjeta de sonido (Out).
 *   04.La onda de la derecha y la izquierda se deben dibujar en la ventana de la aplicación, en la mitad
 *      superior e inferior respectivamente (y es lo que se envía a la tarjeta de audio).
 *   05.La suma de las dos ondas se debe dibujar justo en la mitad de la ventana de la aplicación, entre
 *      las dos ondas anteriores, con un color que resalte en relación a las anteriores.
 *   06.Se deben dibujar las líneas divisorias horizontal y vertical (ejes) que se cruzan en el centro de
 *      la ventana de la aplicación.
 *   07.El movimiento horizontal del mouse controla la fase entre -0.5 (izquierda) y +0.5 (derecha) con
 *      el objeto setPhase.
 *   08.El movimiento vertical del mouse controla la diferencia de frecuencias entre +10Hz (arriba)
 *      y -10Hz (abajo) con el objeto setFrequency.
 *   09.La ventana de la aplicación debe mostrar la amplitud, frecuencia y fase de las dos señales originales.
 *   10.La ventana de la aplicación debe indicar al usuario vuestro nombre y el funcionamiento del programa
 *      (qué hace el mouse, etc.)
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

//Definimos los objetos
Minim minim;
Oscil fixedWaveL;
Oscil variableWaveR;
AudioOutput out;
Pan panL;
Pan panR;


//========================================================================================================
//Función de inicialización
//========================================================================================================
void setup() {

  size(1000, 600);

  //Inicializo motor Minim
  minim = new Minim(this);

  // Inicializamos un oscilador
  variableWaveR = new Oscil(440, 0.5f, Waves.SINE);
  fixedWaveL = new Oscil(440, 0.5f, Waves.SINE);

  //Creación objeto pan para enviar cada onda a un canal
  panR = new Pan(1); //0=center, -1 right -1 left
  panL = new Pan(-1); //0=center, -1 right -1 left

  //Inicializar AudioOutput
  out = minim.getLineOut();

  //Conectamos los osciladores a la salida
  variableWaveR.patch(panR).patch(out);
  fixedWaveL.patch(panL).patch(out);
}


//========================================================================================================
//Bucle principal
//========================================================================================================
void draw() {

  background(0);

  //Dibujamos la forma de las ondas
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    //Para dibujar las ondas se apunta a cada una de las buffers del objeto
    //AudioOutput

    stroke(0, 255, 251);
    strokeWeight(1);

    //Onda superior (derecha - onda variable )
    line(i, 100 - out.right.get(i)*50, i+1, 100 - out.right.get(i+1)*50);

    //Onda inferior (izquierda - onda fija )
    line(i, 500 - out.left.get(i)*50, i+1, 500 - out.left.get(i+1)*50);

    //Suma ondas
    stroke(255, 195, 0);
    strokeWeight(2);
    line(i, 300 - out.mix.get(i)*50, i+1, 300 - out.mix.get(i+1)*50);
  }

  //Texto y datos delainterfaz
  fill(200);
  text("Amp", 10, height-10 );
  text("Amp", 10, height-25 );

  //Dibujar eje de coordenadas
  stroke(255,75);
  strokeWeight(1);
  line(500, 600, 500, 0);
  line(0, 300, 1000, 300);


  //Se muestra informaciónsobre el nombre y
  //elfuncionamiento del programa
  text("Canal izquierdo", 10, 55);
  text("Mixto: ", 10, 265);
  text("Derecho: ", 10, 450);
}

//========================================================================================================
//Función detectar movimientos del ratón
//========================================================================================================
void mouseMoved() {

  // Cada vez que el ratón se mueva se ejecuta esta función
  //Con el movimiento del ratón se modifican los parámetros de amplitud
  //y frecuencia de la onda variable (variableWaveR).
  
  //Se emplea el método map() de processing para controlar el rango de valores
  //map(value, start1, stop1, start2, stop2)

  //En el eje vertical(Y) se modifica la amplitu
  float amplitudeMouse = map(mouseY, 0, height, 1, 0);
  variableWaveR.setAmplitude(amplitudeMouse);

  //En el eje horizontal(X) se modifica la frecuencia
  float frequencyMouse = map(mouseX, 0, width, 150, 1000);
  variableWaveR.setFrequency(frequencyMouse);
}

//========================================================================================================
//Función presionar teclas
//========================================================================================================
void keyPressed() {

  // Cada vez que se pulse una tecla se ejecuta esta función
  // Si se pulsa una tecla entre 1 y 4 se ejecuta este código y se cambia la
  // forma de onda del oscilador
  switch(key) {
  case '+':
    //variableWaveR.setfrequency += 1.0;
    break;
  case '-':
    //variableWaveR.setWaveform(Waves.TRIANGLE);
    break;
  default:
    break;
  }
}
