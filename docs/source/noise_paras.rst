Example for Noise diode Parameters:

  .. figure:: download/noise_paras.png
     
     Screenshot of Observation Log
     
  .. figure:: download/noise_paras-en.png
     
     Screenshot of Observation Log

  From the observation log, the Delay time, Cal On time, and Cal Off time 
  can be read as 251658240, 251658240, and 3523215360, respectively. 
  Their unit is ``4ns`` (nanoseconds).
  The sampling time is 0.5s, so the actual unit here is ``251658240 * 4ns``, 
  meaning the actual sampling time is 0.5*(251658240*4ns).
  Therefore:

  - `-d`:  251658240*4ns / (0.5*(251658240*4ns)) = 2
  - `-m`:  251658240*4ns / (0.5*(251658240*4ns)) = 2
  - `-n`:  3523215360*4ns / (0.5*(251658240*4ns))  =  28
