
<a id="T_2b83"></a>

# <span style="color:rgb(213,80,0)">Quickstart on Control System</span>
<!-- Begin Toc -->

## Table of Contents
&emsp;[Challenges on controlling a hardware](#TMP_2383)
 
&emsp;[Quick introduction to Control System](#TMP_5791)
 
&emsp;&emsp;[How to design it](#TMP_8948)
 
&emsp;[Modeling The Plant](#TMP_98b9)
 
&emsp;[Hardware Requirements](#H_87c0)
 
&emsp;[Wiring Diagram](#TMP_9f80)
 
&emsp;[Demo Procedure](#H_0d08)
 
&emsp;&emsp;[(1) Prepare the project](#H_43cf)
 
&emsp;&emsp;[(2) Run the physical hardware to record input and output](#H_04ed)
 
&emsp;&emsp;&emsp;[For estimation](#H_7fa8)
 
&emsp;&emsp;&emsp;[For validation](#H_3ef0)
 
&emsp;&emsp;[(3) Use System Identification App to estimate plant model](#H_09aa)
 
&emsp;&emsp;[(4) Simulate and tune](#TMP_0a19)
 
&emsp;&emsp;[(5) Test with the hardware](#H_5f81)
 
&emsp;[References](#H_23ad)
 
<!-- End Toc -->
<a id="TMP_2383"></a>

# Challenges on controlling a hardware
-  How to get started with available hardware on market? 
-  What to learn and how to quickly implement physically? 
-  Can I create a controller without knowing much about the "plant"? 
-  Any fast way of tuning PID parameters? 
<a id="TMP_5791"></a>

# Quick introduction to Control System

Simple closed\-loop control system example:

<p style="text-align:left">
   <img src="./resources/README/image_0.png" width="744" alt="image_0.png">
</p>

<a id="TMP_8948"></a>

## How to design it
1.  Model the plant
2. Tune the controller
3. Test & Verify
4. Deploy
<a id="TMP_98b9"></a>

# Modeling The Plant
<p style="text-align:left">
   <img src="./resources/README/image_1.png" width="653" alt="image_1.png">
</p>



The problem is **I don't know the specification** of the motor and its driver (the plant)

<p style="text-align:left">
   <img src="./resources/README/image_2.png" width="744" alt="image_2.png">
</p>


So, this is where we need **System Identification**

<a id="H_87c0"></a>

# Hardware Requirements
-  [Arduino Uno R3](https://www.digikey.com/en/products/detail/arduino/A000066/2784006) 
-  [Type\-B USB Cable](https://tokopedia.link/Nc4U64hwgSb) 
-  [L293D](https://www.digikey.com/en/products/detail/stmicroelectronics/L293D/634700) 
-  [12VDC brushed motor](https://tokopedia.link/gaId8sawgSb) (or similar) 
-  [12V power supply](https://www.digikey.com/en/products/detail/tri-mag-llc/L6R06H-120/7682617) 
-  [12V barrel jack power socket](https://www.digikey.com/en/products/detail/lumberg-inc/1610-07/25602821) 
<a id="TMP_9f80"></a>

# Wiring Diagram
<p style="text-align:left">
   <img src="./resources/README/image_3.png" width="723" alt="image_3.png">
</p>

<a id="H_0d08"></a>

# Demo Procedure
<a id="H_43cf"></a>

## (1) Prepare the project
```matlab
open system_identification_arduino.prj
```
<a id="H_04ed"></a>

## (2) Run the physical hardware to record input and output
```matlab
load_system("record_plant");
set_param("record_plant",SimulationMode="external");
```
<a id="H_7fa8"></a>

### For estimation
```matlab
start_recording("record_plant");
estimation_iddata = recording_output(yout);
save('Output\estimation.mat', 'estimation_iddata');
plot(estimation_iddata)
```

<center><img src="./resources/README/figure_0.png" width="562" alt="figure_0.png"></center>

<a id="H_3ef0"></a>

### For validation
```matlab
start_recording("record_plant");
validation_iddata = recording_output(yout);
save('Output\validation.mat', 'validation_iddata');
plot(validation_iddata)
```

<center><img src="./resources/README/figure_1.png" width="562" alt="figure_1.png"></center>

<a id="H_09aa"></a>

## (3) Use System Identification App to estimate plant model
<p style="text-align:left">
   <img src="./resources/README/image_4.png" width="711" alt="image_4.png">
</p>


<p style="text-align:left">
   <img src="./resources/README/image_5.png" width="671" alt="image_5.png">
</p>


<p style="text-align:left">
   <img src="./resources/README/image_6.png" width="686" alt="image_6.png">
</p>


<p style="text-align:left">
   <img src="./resources/README/image_7.png" width="280" alt="image_7.png">
</p>


Use these object names and click import for each of them.

1.  estimation\_iddata
2. validation\_iddata

Then click "Close".


You will see "estimation\_idddata" and "validation\_iddata" in Data Views. Drag and drop accordingly to this illustration.

<p style="text-align:left">
   <img src="./resources/README/image_8.png" width="641" alt="image_8.png">
</p>


<p style="text-align:left">
   <img src="./resources/README/image_9.png" width="276" alt="image_9.png">
</p>


Configure exactly as below. Feel free to modify if you know what you're doing.

<p style="text-align:left">
   <img src="./resources/README/image_10.png" width="354" alt="image_10.png">
</p>


Then click "Estimate" and wait.


Once done, drag the result as below to workspace.

<p style="text-align:left">
   <img src="./resources/README/image_11.png" width="563" alt="image_11.png">
</p>


Done! Now you have "plant\_model" variable in Workspace, which represents your motor and tachometer as a plant.


**If you want instant result**, here's the custom function:

```matlab
plant_model = identify_the_plant(estimation_iddata, validation_iddata);
```
<a id="TMP_0a19"></a>

## (4) Simulate and tune
```matlab
open tune_controller.slx
```

Double click the PID block

<p style="text-align:left">
   <img src="./resources/README/image_12.png" width="450" alt="image_12.png">
</p>


Make sure changes applied and tuning method is "Transfer Function Based", then click Tune button

<p style="text-align:left">
   <img src="./resources/README/image_13.png" width="428" alt="image_13.png">
</p>


Adjust these sliders below then hit "Update Block" button.

<p style="text-align:left">
   <img src="./resources/README/image_14.png" width="606" alt="image_14.png">
</p>


Click OK on Block Parameter dialog. Your PID parameters (Kp, Ki, Kd, and Kn) are now synced to other models via "Data\\tuning\_parameters.sldd".

<a id="H_5f81"></a>

## (5) Test with the hardware
```matlab
open hardware_in_the_loop.slx
```
<a id="H_23ad"></a>

# References
-  [Get Started with System Identification Toolbox](https://www.mathworks.com/help/ident/getting-started-1.html) 
