/**
 * Pregunta 03
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
 * DESCRIPCIÓN ESTRUCTURA GENERAL DEL CÓDIGO:
 * =======================================================================================================
 * Siguiendo los ejemplos presentados en la unidad, para la realización del siguiente ejercicio se ha
 * estructurado el código de la siguiente manera:
 * 
 * 1- Importar los paquetes necesarios, definición de variables y configuración general de la ventana.
 * 2- Inicialización del motor minim así como la creación de un AudioSampler por cada uno de los ficheros de 
      audio que se han de leer y disparar desde el directorio data.
 * 3- Se parametriza la lectura del buffer a través de map y se dibujan las ondas para cada uno de los canales.
 * 4- Se crea el texto y los elementor de interfaz adicionales.
 * 5- El resto del código está orientado a crear las condiciones de pulsar alguna de
 *    las teclas asignadas de forma que se disparen/reproduzcan los diferentes samplers asignados a cada
 *    uno de los valores de la escala mayor.
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
AudioSample sampleZDo; //Objeto para reproducir del sonido "Do"
AudioSample sampleXRe; //Objeto para reproducir del sonido "Re"
AudioSample sampleCMi; //Objeto para reproducir del sonido "Mi"
AudioSample sampleVFa; //Objeto para reproducir del sonido "Fa"
AudioSample sampleBSol; //Objeto para reproducir del sonido "Sol"
AudioSample sampleNLa; //Objeto para reproducir del sonido "La"
AudioSample sampleMSi; //Objeto para reproducir del sonido "Si"
private PFont font;//Variable para definir la fuente de la interfaz


//========================================================================================================
//Función de inicialización
//========================================================================================================
void setup() {

  //Espeficiación de los parametros de la ventana, con Processing 3D
  size(1000, 600, P3D);
  font = createFont("Poppins-Regular.ttf", 13);//Tipografía
  textFont(font);//Asignación de la tipografía
  
  //Se inicializa el motor Minim
  minim = new Minim(this);

  //Se cargan desde el directoria data del proyecto los sonidos para cada sample
  //loadSample (nombreFichero, bufferLectura) - En caso de que el sonido se escuche 
  //con alteraciones podemos aumentar el buffer
  //Para cada sonido comprobamos que exista o se carge el fichero en caso 
  //contrario se muestra un mensaje por consola
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
  
  //Color de fondo y color y grosor de las lineas
  background(229, 231, 233);
  stroke(52, 50, 48);
  fill(52, 50, 48);

  //Se dibujan las formas de las ondas
  //Por cada bit del mix buffer se especifica un valor de cordenadas a través del map para 
  //posteriormente posicionar y dibujar la onda en la pantalla
  for (int i = 0; i < sampleZDo.bufferSize() - 1; i++)
  {
    
    //Se mapean los valores para las coordenadas
    float x1 = map(i, 0, sampleZDo.bufferSize(), 0, width);
    float x2 = map(i+1, 0, sampleZDo.bufferSize(), 0, width);
    
    //Se dibujan las ondas
    line(x1, 100 - sampleZDo.mix.get(i)*50, x2, 100 - sampleZDo.mix.get(i+1)*50);
    line(x1, 150 - sampleXRe.mix.get(i)*50, x2, 150 - sampleXRe.mix.get(i+1)*50);
    line(x1, 200 - sampleCMi.mix.get(i)*50, x2, 200 - sampleCMi.mix.get(i+1)*50);
    line(x1, 250 - sampleVFa.mix.get(i)*50, x2, 250 - sampleVFa.mix.get(i+1)*50);
    line(x1, 300 - sampleBSol.mix.get(i)*50, x2, 300 - sampleBSol.mix.get(i+1)*50);
    line(x1, 350 - sampleNLa.mix.get(i)*50, x2, 350 - sampleNLa.mix.get(i+1)*50);
    line(x1, 400 - sampleMSi.mix.get(i)*50, x2, 400 - sampleMSi.mix.get(i+1)*50);
  }

  //Se crea el texto y se añade la imagen del logotipo que aparecen en la interfaz
  text("Creador: Pablo Pérez Sineiro", 10, height-107);
  text("Email: pperezsi@uoc.edu", 10, height-90);
  text("Se han de pulsar las teclas 'z','x','c','v','b','n','m'; para hacer sonar cada nota de la escala mayor.", 10, height-134);
  
  //Se lee el fichero de imagen desde el directorio data del proyecto y se le 
  //asigna una posición y tamaño en la ventana
  PImage logotipo = loadImage("logo_uoc.png");
  image(logotipo, 10, height-80, 198, 70);
}


//========================================================================================================
//Función presionar teclas
//========================================================================================================
void keyPressed() 
{
  // Cada vez que se pulse una tecla sea mayusculas o miníscula 
  // se comprueba que letra se ha pulsado y siempre que coincida con alguna de las 
  // indicadas (sea mayúscula o minúscula) se disparara el sampler correspondiente.
  if ( key == 'z' || key == 'Z' ) sampleZDo.trigger();
  if ( key == 'x' || key == 'X' ) sampleXRe.trigger();
  if ( key == 'c' || key == 'C' ) sampleCMi.trigger();
  if ( key == 'v' || key == 'V' ) sampleVFa.trigger();
  if ( key == 'b' || key == 'B' ) sampleBSol.trigger();
  if ( key == 'n' || key == 'N' ) sampleNLa.trigger();
  if ( key == 'm' || key == 'M' ) sampleMSi.trigger();
}
