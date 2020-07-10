!> @brief Programa para leer los datos de archivos de temis.nl
!>   formato TOMS ascii
!>   Create output file and write results in binary file and descriptor file
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  06/26/2020
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!>  @param variable array with colum data
!>  @param cfile file names array
!>  @param i  counter for col_number values
!>  @param j  counter for row_number values
!>  @param irec record counter
!>  @param itim  time counter for files File_num
!>  @param cdum character dummy variable
!>  @param number_lon Number of colums in file longitude values
!>  @param number_lat Number of rows in file latitude values
!>  @param num_files Number of times  each file has one time
!>  @param ivalor_no2 Integer value of the column
!>  @param valor_no2  Real values of the column
!>  @param size_grid tamaño de la celda
  program procesa_TOMS
  integer, parameter :: number_lon=2880,number_lat=1440,num_files=12
  integer, dimension(number_lon,number_lat) :: ivalor_no2
  real(4),dimension(number_lon,number_lat) :: valor_no2
  character(len=14),dimension(num_files) :: cfile
  integer :: i,j,irec,itim
  real(4) :: origin_lon= 179.9375_4
  real(4) :: origin_lat= -89.9375_4
  real(4) :: size_grid=0.125_4
  character(len=10) :: cdum
  data cfile/'no2_201901.asc','no2_201802.asc','no2_201803.asc','no2_201804.asc',&
  &         'no2_201805.asc','no2_201806.asc','no2_201807.asc','no2_201808.asc',&
  &         'no2_201809.asc','no2_201810.asc','no2_201811.asc','no2_201812.asc'/
  open (unit=8,file='tropomi_no2_2018.dat', FORM='UNFORMATTED', ACCESS='DIRECT'&
  &,RECL=4*number_lon*number_lat,convert='big_endian')
  irec=1
  do itim=1,num_files
    open (unit=10,file=cfile(itim),STATUS='OLD')
    print *,'Lee ',cfile(itim)
    do j=1,4
      read(10,'(A10)')cdum
    end do
    do j=1,number_lat
      read(10,'(A10)')cdum
      read(10,'(20I4)')(ivalor_no2(i,j),i=1,number_lon)
      do i=1,number_lon
        valor_no2(i,j)=ivalor_no2(i,j)*1.0
      end do
    end do
    close(10)
    print *,'Guarda ',itim,cfile(itim)
    write(8,rec=irec)((valor_no2(i,j),i=1,number_lon),j=1,number_lat)
    irec=irec+1
    valor_no2=-999
  end do
  close(8)
  print *,'Ctl file'
  open(unit=12,file='tropomi_no2_2018.ctl')
  write(12,200)
  write(12,201)
  write(12,202)
  write(12,203)number_lon,origin_lon,size_grid
  write(12,204)number_lat,origin_lat,size_grid
  write(12,205)
  write(12,206)num_files
  write(12,207)
  write(12,208)
  write(12,209)
  close(12)
120    format(12000f7.0)
200   format('DSET ^tropomi_no2_2018.dat')
201   format('Title NO2 total column molec10^13/cm^2'/'options big_endian')
202   format('UNDEF -999')
203   format('xdef',I7,' linear ',f9.4,f12.7)
204   format('ydef',I7,' linear ',f9.4,f12.7)
205   format('zdef 1 linear 1 1')
206   format('tdef',I3,' linear 00z01jan2018 1mo')
207   format('vars 1')
208   format('    NO2 1 99  NO2 total column tropomi')
209   format('endvars')
      end program  procesa_TOMS
	  

