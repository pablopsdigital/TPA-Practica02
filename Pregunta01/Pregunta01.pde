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
 * DESCRIPCIÓN ESTRUCTURA GENERAL DEL CÓDIGO:
 * =======================================================================================================
 * Siguiendo los ejemplos presentados en la unidad, para la realización del siguiente ejercicio se ha
 * estructurado el código de la siguiente manera:
 * 
 * 1- Importar los paquetes necesarios, definición de variables y configuración general de la ventana.
 * 2- Inicialización del motor minim así como la creación de dos osciladores para cada una de las ondas a representar.
 * 3- Creación de objeto pan para cada canal para enviar a cada oscilador a uno de los canales.
 * 4- Finalmente se conecta cada canal a la salida a través de un objeto patch.
 * 5- Se dibujan las tres ondas, realizando para la onda del medio la suma de las dos anteriores aunque
 *    en ningún momento se está dando salida de audio a dicha onda, sino a las dos ondas por separado.
 * 6- El resto del código está orientado a crear las condiciones en caso de mover el ratón o de pulsar alguna de
 *    las teclas asignadas de forma que se modifiquen los parametros indicados en el enumciado modificando tan
 *    solo una de las ondas indicadas.
 *
 * NOTA: En cada línea se especifica con mayor claridad la funcionalidad de cada apartado del código.
 *
 */

//========================================================================================================
//Importación de paquetes necesarios
//========================================================================================================
import ddf.minim.*;
import ddf.minim.ugens.*;

//========================================================================================================
//Definición de variables
//========================================================================================================
Minim minim; //Objeto minim
Oscil fixedWaveL; //Oscilador para la onda fija
Oscil variableWaveR; //Oscilador onda variable
AudioOutput out; // Objeto para la salida de audio
Pan panL;// Objeto UGen pan para enviar la salida mono al canal izquierdo
Pan panR; //Objeto UGen pan para enviar la salida mono al canal izquierdo
float newPhase; //Variable de apoyo para la fase
float newFrequency;//Variable de apoyo para la frecuencia
private PFont font; //Variable para definir la fuente de la interfaz


//========================================================================================================
//Función de inicialización
//========================================================================================================
void setup() {

  //Espeficiación de los parametros de la ventana
  size(1000, 600);//Tamaño
  font = createFont("Poppins-Regular.ttf", 13);//Tipografía
  textFont(font);//Asignación de la tipografía

  //Se inicializa el motor Minim
  minim = new Minim(this);

  // Inicialización de cada uno de los dos osciladores
  variableWaveR = new Oscil(440, 0.5f, Waves.SINE); //Onda variable (frecuencia, amplitud, tipo onda senoidal)
  fixedWaveL = new Oscil(440, 0.5f, Waves.SINE); //Onda fija (frecuencia, amplitud, tipo onda senoidal)

  //Creación objeto pan para enviar cada onda a un canal
  panR = new Pan(1); //0=center, -1 right -1 left
  panL = new Pan(-1); //0=center, -1 right -1 left

  //Inicialización salida audio (AudioOutput)
  out = minim.getLineOut();

  //Se conectan los osciladores a cada uno de los canales y posterioremente a la salida de audio
  variableWaveR.patch(panR).patch(out);
  fixedWaveL.patch(panL).patch(out);
}


//========================================================================================================
//Bucle principal
//========================================================================================================
void draw() {

  //Color de fondo de la ventana
  background(0);

  //Se dibujan las formas de las ondas
  //Por cada bit del buffer de la salida
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    //Se establece el color y grosor de la linea
    stroke(0, 255, 251);
    strokeWeight(1);

    //Por cada bit del buffer se dibuja un punto de la linea de cada onda estableciendo las coordenadas de la ventana 
    //Onda derecha - onda variable
    line(i, 100 - out.right.get(i)*50, i+1, 100 - out.right.get(i+1)*50);

    //Onda izquierda - onda fija
    line(i, 500 - out.left.get(i)*50, i+1, 500 - out.left.get(i+1)*50);

    //En este caso se dibuja la onda central, suma de las dos anteriores
    //Se asigna el color y el grosor de la linea de la onda
    stroke(255, 195, 0);
    strokeWeight(2);
    //Se dibuja la linea de la onda
    line(i, 300 - out.mix.get(i)*50, i+1, 300 - out.mix.get(i+1)*50);
  }

  //Se crea el texto y datos que aparecen en la interfaz
  fill(200);
  text("Creado por: Pablo Pérez Sineiro, email: pperezsi@uoc.edu", 10, height-50 );
  text("El movimiento horizontal del ratón controla la fase y el vertical controla la frecuencia de la onda superior.", 10, height-30);
  text("También se puede ajustar la velocidad con las teclas '+' para subir y '-' para bajar. "+
    "En caso de querer reiniciar los valores por defecto con la tecla '.'", 10, height-15);

  //Texto del canal izquierdo - variable
  text("Canal izquierdo:", 10, 55);
  text("Amplitud:" + variableWaveR.amplitude.getLastValue(), 150, 55 );
  text("Frecuencia:"  + variableWaveR.frequency.getLastValue(), 300, 55 );
  text("Fase:" + variableWaveR.phase.getLastValue(), 505, 55 );

  //Texto del canal derecho - fijo
  text("Mixto: ", 10, 265);
  text("Canal derecho: ", 10, 450);
  text("Amplitud:" + fixedWaveL.amplitude.getLastValue(), 150, 450 );
  text("Frecuencia:"  + fixedWaveL.frequency.getLastValue(), 300, 450 );
  text("Fase:" + fixedWaveL.phase.getLastValue(), 505, 450 );
  
  //Se dibuja el eje de coordenadas
  stroke(255, 75);
  strokeWeight(1);
  line(500, 600, 500, 0);
  line(0, 300, 1000, 300);
}

//========================================================================================================
//Función detectar movimientos del ratón
//========================================================================================================
void mouseMoved() {

  //Cada vez que el ratón se mueva se ejecuta esta función
  //Con el movimiento del ratón se modifican los parámetros de amplitud
  //y frecuencia de la onda variable (variableWaveR).

  //Se emplea el método map() de processing para controlar el rango de valores
  //map(value, start1, stop1, start2, stop2)

  //En el eje vertical(Y) se modifica la amplitud
  newPhase = map (mouseX, 0, width, -0.5, 0.5);
  variableWaveR.setPhase(newPhase);

  //En el eje horizontal(X) se modifica la frecuencia
  //=====================================================================
  //OJO: Aclaración de dos posibles formas de entender el ejercicio
  //=====================================================================
  //FORMA 1:En caso de mantener frecuencia entre intevalo fijo
  //newFrequency = map(mouseY, 0, height, 430, 450);
  
  //FORMA 2:En este caso la frecuencia varian +10 y -10 independientemente del valor
  newFrequency = map(mouseY, 0, height, variableWaveR.frequency.getLastValue()+ 10, variableWaveR.frequency.getLastValue()- 10);
  variableWaveR.setFrequency(newFrequency);
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
    //Al pulsar la tecla - se sube 1Hz la frecuencia de las dos ondas
    newFrequency = fixedWaveL.frequency.getLastValue()+ 1;
    variableWaveR.setFrequency(newFrequency);
    fixedWaveL.setFrequency(newFrequency);
    break;

  case '-':
    //Al pulsar la tecla - se baja 1Hz la frecuencia de las dos ondas
    newFrequency = fixedWaveL.frequency.getLastValue()- 1;
    variableWaveR.setFrequency(newFrequency);
    fixedWaveL.setFrequency(newFrequency);
    break;

  case '.':
    //Apartado adicional al ejercicio
    //Al pulsar la tecla - se reinician los valores iniciales
    variableWaveR.setFrequency(440);
    fixedWaveL.setFrequency(440);
    break;

  default:
    break;
  }
}
