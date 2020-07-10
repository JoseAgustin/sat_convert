!>  @brief
!>  Conversion program from ESRI grid format to GrADs binary
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
!>  @param col_number Number of colums in file longitude values
!>  @param row_number Number of rows in file latitude values
!>  @param File_num Number of times  each file has one time
!>  @param variable Integer value of the NO2 column
!>  @param cell_dim tamaño de la celda
 program lee_ESRI
    integer, parameter :: col_number=2880,row_number=1440,File_num=12
    real(4), dimension(col_number,row_number) :: variable
    character(len=14),dimension(File_num) :: cfile
    integer :: i,j,irec,itim
    real(4) :: lon_origin=-179.87500_4
    real(4) :: lat_origin= -89.87500_4
    real(4) :: cell_dim=0.125_4
    character(len=10) :: cdum
    data cfile/'no2_201801.grd','no2_201802.grd','no2_201803.grd','no2_201804.grd',&
	 &         'no2_201805.grd','no2_201806.grd','no2_201807.grd','no2_201808.grd',&
	 &         'no2_201809.grd','no2_201810.grd','no2_201811.grd','no2_201812.grd'/
	   open (unit=8,file='omi_no2_2018.dat',FORM='UNFORMATTED',ACCESS='DIRECT'&
	   &,RECL=4*col_number*row_number,convert='big_endian')
	   irec=1
	   do itim=1,File_num
	      open (unit=10,file=cfile(itim))
              write(6,'(A,x,A)')' ** Reads File: ',cfile(itim)
	      do j=1,7
	       read(10,'(A10)')cdum
	      end do
	      do j=1,row_number
	       read(10,*)(variable(i,j),i=1,col_number)
	      end do
	      close(10)
	      write(6,'(A,I4)')'  *** Stores time: ',itim
	      write(8,rec=irec)((variable(i,j),i=1,col_number),j=row_number,1,-1)
          irec=irec+1
		  variable=-999
	   end do
	   close(8)
    print *,'Creates omi_no2_2018.ctl  file'
	   open(unit=12,file='omi_no2_2018.ctl')
	   write(12,200)
	   write(12,201)
	   write(12,202)
	   write(12,203)col_number,lon_origin,cell_dim
	   write(12,204)row_number,lat_origin,cell_dim
	   write(12,205)
	   write(12,206)File_num
	   write(12,207)
	   write(12,208)
	   write(12,209)
	   close(12)
120   format(12000f7.0)
200   format('DSET ^omi_no2_2018.dat')
201   format('Title NO2 total column molec10^15/cm^2 OMI'/'options big_endian')
202   format('UNDEF -999')
203   format('xdef',I7,' linear ',f9.4,f12.7)
204   format('ydef',I7,' linear ',f9.4,f12.7)
205   format('zdef 1 linear 1 1')
206   format('tdef',I3,' linear 00z01jan2018 1mo')
207   format('vars 1')
208   format('    NO2 1 99  NO2 OMI total column ')
209   format('endvars')
      end program lee_ESRI
