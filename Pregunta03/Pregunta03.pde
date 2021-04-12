/**
 * Pablo Pérez Sineiro
 * 26/03/2021
 *
 * =======================================================================================================
 * ENUNCIADO PREGUNTA 3:
 * =======================================================================================================
 * En esta pregunta implementaremos un pequeño sampler que se tocará con el teclado del ordenador. Los
 * sonidos del sampler se generan cantando (y con vuestra propia voz) una escala mayor ascendente con 
 * sonidos cortos, tipo “pap, pep, pip…”, con las 8 notas de la escala. Cada sonido de estos 
 * (correspondiente a cada nota) será activado con una tecla, por ejemplo, siguiendo la secuencia:
 * ‘z’,’x’,’c’,’v’,’b’,’n’,’m’,’,’. En concreto, se pide:
 * 
 *  01.Con las herramientas de grabación disponibles, grabar, con la propia voz, un fichero siguiendo
 *     una escala mayor. La escala de do mayor suena como en los siguientes ejemplos de FreeSound:
 *      a. https://freesound.org/people/marianasasousa/sounds/508679/
 *      b. https://freesound.org/people/mooncubedesign/sounds/420501/
 *      c. https://freesound.org/people/dobroide/sounds/6497/
 *  02.Con las herramientas de edición disponibles, cortar el fichero grabado en pequeños trozos, cada
 *     uno correspondiente a una nota de la escala, y exportarlos en formato .wav, 1 canal (mono), y 
 *     frecuencia de muestreo fm=44100Hz.
 *  03.A partir del ejemplo “TriggerASample” disponible en los ejemplos de Processing 
 *     (File -> Examples -> Contributed Libraries -> Minim -> Basics”, generar un sketch nuevo y guardarlo con el nombre
 *     “Pregunta 3”.
 *  04.Dentro de la carpeta del sketch (“Pregunta 3”), crear una subcarpeta data y copiar en su interior
 *     los ficheros de audio generados en el apartado 2 (p.ej. “C3.wav”, “D3.wav”, etc.).
 *  05.Diseñar el programa para poder disparar (trigger) las distintas notas con la secuencia de
 *     teclas ‘z’,’x’,’c’,’v’,’b’,’n’,’m’,’,’.
 *  06.El programa solo debe tener control sobre el disparo de la muestra, pero no para detenerla (de
 *    ahí que deban ser notas cortas).
 *  07.Dibujar las 8 señales de audio en la ventana de la aplicación, una debajo de otra, de forma que
 *     al apretar una tecla se muestre la forma de onda del fichero de audio disparado.
 *  08.Incluir en la ventana de la aplicación, de forma discreta, el nombre del estudiante y el logotipo
 *     de la UOC.
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
AudioSample sampleZDo;
AudioSample sampleXRe;
AudioSample sampleCMi;
AudioSample sampleVFa;
AudioSample sampleBSol;
AudioSample sampleNLa;
AudioSample sampleMSi;

private PFont font;


//========================================================================================================
//Función de inicialización
//========================================================================================================
void setup() {

  size(1000, 600, P3D);
  font = createFont("Poppins-Regular.ttf", 13);
  textFont(font);
  minim = new Minim(this);

  //Cargar sonidos para le sample
  //loadSample (nombreFichero, buffer)
  //En caso de que el sonido se escuche con alteraciones podemos aumentar el buffer
  sampleZDo = minim.loadSample("do.wav", 512);
  if ( sampleZDo == null ) println("No se ha cargado el sonido Do");

  sampleXRe = minim.loadSample("re.wav", 512);
  if ( sampleXRe == null ) println("No se ha cargado el sonido Re");

  sampleCMi = minim.loadSample("mi.wav", 512);
  if ( sampleCMi == null ) println("No se ha cargado el sonido Mi");

  sampleVFa = minim.loadSample("fa.wav", 512);
  if ( sampleVFa == null ) println("No se ha cargado el sonido Fa");

  sampleBSol = minim.loadSample("sol.wav", 512);
  if ( sampleBSol == null ) println("No se ha cargado el sonido Sol");

  sampleNLa = minim.loadSample("la.wav", 512);
  if ( sampleNLa == null ) println("No se ha cargado el sonido La");

  sampleMSi = minim.loadSample("si.wav", 512);
  if ( sampleMSi == null ) println("No se ha cargado el sonido Si");
}


//========================================================================================================
//Bucle principal
//========================================================================================================
void draw() {

  background(229, 231, 233);
  stroke(52, 50, 48);
  fill(52, 50, 48);

  //Por cada use the mix buffer to draw the waveforms.
  for (int i = 0; i < sampleZDo.bufferSize() - 1; i++)
  {
    float x1 = map(i, 0, sampleZDo.bufferSize(), 0, width);
    float x2 = map(i+1, 0, sampleZDo.bufferSize(), 0, width);
    float x3 = map(i+2, 0, sampleZDo.bufferSize(), 0, width);
    float x4 = map(i+3, 0, sampleZDo.bufferSize(), 0, width);
    float x5 = map(i+4, 0, sampleZDo.bufferSize(), 0, width);
    float x6 = map(i+5, 0, sampleZDo.bufferSize(), 0, width);
    float x7 = map(i+6, 0, sampleZDo.bufferSize(), 0, width);
    line(x1, 100 - sampleZDo.mix.get(i)*50, x2, 100 - sampleZDo.mix.get(i+1)*50);
    line(x1, 150 - sampleXRe.mix.get(i)*50, x2, 150 - sampleXRe.mix.get(i+1)*50);
    line(x1, 200 - sampleCMi.mix.get(i)*50, x2, 200 - sampleCMi.mix.get(i+1)*50);
    line(x1, 250 - sampleVFa.mix.get(i)*50, x2, 250 - sampleVFa.mix.get(i+1)*50);
    line(x1, 300 - sampleBSol.mix.get(i)*50, x2, 300 - sampleBSol.mix.get(i+1)*50);
    line(x1, 350 - sampleNLa.mix.get(i)*50, x2, 350 - sampleNLa.mix.get(i+1)*50);
    line(x1, 400 - sampleMSi.mix.get(i)*50, x2, 400 - sampleMSi.mix.get(i+1)*50);
  }

  //Textos y logotipo
  text("Creador: Pablo Pérez Sineiro", 10, height-107);
  text("Email: pperezsi@uoc.edu", 10, height-90);
  PImage logotipo = loadImage("logo_uoc.png");
  image(logotipo, 10, height-80, 198, 70);
}

//========================================================================================================
//Función detectar movimientos del ratón
//========================================================================================================
void mouseMoved() {
}

//========================================================================================================
//Función presionar teclas
//========================================================================================================
void keyPressed() 
{
  if ( key == 'z' || key == 'Z' ) sampleZDo.trigger();
  if ( key == 'x' || key == 'X' ) sampleXRe.trigger();
  if ( key == 'c' || key == 'C' ) sampleCMi.trigger();
  if ( key == 'v' || key == 'V' ) sampleVFa.trigger();
  if ( key == 'b' || key == 'B' ) sampleBSol.trigger();
  if ( key == 'n' || key == 'N' ) sampleNLa.trigger();
  if ( key == 'm' || key == 'M' ) sampleMSi.trigger();
}
