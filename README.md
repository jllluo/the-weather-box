# The Weather Box

The Weather Box is a light gadget that displays animated weather patterns. The weather changes between rain, snow, and lightning in response to movement. And the perspective corresponds to the orientation of the device.

Made with Processing and Raspberry Pi.

Demo - https://vimeo.com/307826619


## Concept

The project started with the idea of giving light some sort of form that makes it feel tangible and corporeal. There are some precedent projects that make the interaction with light really fun, like <a href="http://www.espadaysantacruz.com/projects/light-kinetics" target="_blank">Light Kinetic by Espadaysantacruz Studio</a>, <a href="http://www.nipek.jp/interactive-x-light.html" target="_blank">The Play of Brilliants by Nipek</a>, and <a href="https://learn.adafruit.com/matrix-led-sand" target="_blank">LED Matrix Sand Toy by Ruiz Brothers</a>.

Inspired by these projects, I started designing a light box that responds to motion. I chose weather patterns to be the subject of the animation because they would be recognizable and fun to watch in the form of light. They also lend themselves to having varying views from different perspectives, which would make the connection between the display and the movement of the device very natural.


## Mechanics

The project uses a Raspberry Pi with a 32x32 LED matrix and a 6-axis accelerometer/gyroscope wired to it. I used Processing to code the weather animations and displayed the graphics on the LED matrix using the <a href="https://github.com/hzeller/rpi-rgb-led-matrix">LED-matrix library</a> created by Henner Zeller. An MPU6050 accelerometer/gyroscope is used to capture the orientation and rotation data. The motion data is integrated with the Processing code using its Hardware I/O functionalities, making it possible to switch between different animation patterns with movement.

Here are some helpful guides I followed for wiring up the hardware:
https://github.com/hzeller/rpi-rgb-led-matrix/blob/master/wiring.md
https://learn.sparkfun.com/tutorials/rgb-panel-hookup-guide

How my components were wired up: <br>
<img src="https://github.com/jllluo/the-weather-box/blob/master/images/schematics.png" width="60%" display="inline">
<img src="https://github.com/jllluo/the-weather-box/blob/master/images/wiring.jpg" width="35%" display="inline">


## Assembly

The electronics are enclosed in a wooden casing. A sheet of transluscent acrylic is attached over the LED panel, leaving a small distance in between to diffuse the light coming from the pixels. <br><br>
<img src="https://github.com/jllluo/the-weather-box/blob/master/images/showcase.jpg" width="48%" display="inline">
<img src="https://github.com/jllluo/the-weather-box/blob/master/images/showcase2.jpg" width="48%" display="inline">


