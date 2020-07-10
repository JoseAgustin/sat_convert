# Converts Satellite ascii to GrADs binary

Converts ascii data from ESRI or TOMS data into GrADS binary format and creates the descriptio file _ctl_


input files:

      TOMS or ESRI  ! ascii file
  
  From  ESRI:

      no2_201801.grd   no2_201802.grd   no2_201803.grd   no2_201804.grd
      no2_201805.grd   no2_201806.grd   no2_201807.grd   no2_201808.grd   
      no2_201809.grd   no2_201810.grd   no2_201811.grd   no2_201812.grd        
      
 From TOMS
 
      no2_201802.asc  no2_201803.asc  no2_201804.asc  no2_201805.asc 
      no2_201806.asc  no2_201807.asc  no2_201808.asc  no2_201809.asc
      no2_201810.asc  no2_201811.asc  no2_201812.asc  no2_201901.asc
             
output files:

data files on binary format and description file

From  ESRI:

    omi_no2_2018.dat   omi_no2_2018.ctl
  

From TOMS

    tropomi_no2_2018.dat  tropomi_no2_2018.ctl 


### ESRI format

      ncols 2880
      nrows 1440
      xllcorner -180.0
      yllcorner  -90.0
      cellsize 0.125
      nodata_value -999
      version 2.0
      -999 -999 -999 -999 -999 -999 ...

### TOMS format

    TROPOMI monthly-mean tropospheric NO2 columns, version 1.0
    Year 2018 Month  2, units: 1e13 molecules/cm2, undef=-999
    Longitudes:  2880 bins centered on 179.9375 W to 179.9375 E  (0.125 degree steps)
    Latitudes :  1440 bins centered on  89.9375 S to  89.9375 N  (0.125 degree steps)
    lat=  -89.9375
    3   1   0   2   3   7   7   7   2  10   3   2   4   4   6   0   3   3   3   2

## Namelist file

Se emplea el archivo `satelite.nml` para definir el formato y las variables a usar con el progama `convierte.exe`  el formato que tiene es el siguiente:

### ESRI format

    !
    !   Namelist file for satelite extraction data
    !
    &formato_ascii  ! TOMS or ESRI
    ascii="ESRI"
    ! Numero de archivos
    num_files= 12
    /
    &archivos
    cfile="no2_201801.grd","no2_201802.grd","no2_201803.grd","no2_201804.grd","no2_201805.grd","no2_201806.grd","no2_201807.grd","no2_201808.grd","no2_201809.grd","no2_201810.grd","no2_201811.grd","no2_201812.grd",
    /

### TOMS format

    !
    !   Namelist file for satelite extraction data
    !
    &formato_ascii  ! TOMS or ESRI
    ascii="TOMS"
    ! Numero de archivos
    num_files= 12
    /
    &archivos
    cfile='no2_201901.asc','no2_201802.asc','no2_201803.asc','no2_201804.asc','no2_201805.asc','no2_201806.asc','no2_201807.asc','no2_201808.asc','no2_201809.asc','no2_201810.asc','no2_201811.asc','no2_201812.asc'
    /

## Additional links

The **ascii** data can be obtained from [TEMIS](http://www.temis.nl/index.php) web site

The **GrADS** program can be downloaded from [Grads web site](http://cola.gmu.edu/grads/)
