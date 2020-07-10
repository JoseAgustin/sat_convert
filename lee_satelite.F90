!>  @brief Variables definition
!>  @author  Jose Agustin Garcia Reynoso
!>  @date  07/09/2020
!>  @version  1.0
!>  @copyright Universidad Nacional Autonoma de Mexico.
!>  @param cell_dim tamaño de la celda
!>  @param number_lon Number of colums in file longitude values
!>  @param number_lat Number of rows in file latitude values
!>  @param File_num Number of times  each file has one time
!>  @param ino2_column Integer value of the NO2 column
!>  @param no2_column  Real value of the NO2 column
!
module variables
integer, parameter :: number_lon=2880,number_lat=1440
integer :: num_files
real(4), dimension(number_lon,number_lat) :: no2_column
integer,dimension(number_lon,number_lat) :: ino2_column
character(len=14),allocatable :: cfile(:)
character(len=4) :: ascii
real(4) :: lon_origin=-179.87500_4
real(4) :: lat_origin= -89.87500_4
real(4) :: cell_dim=0.125_4
common /vasdata/ino2_column,lon_origin,lat_origin,cell_dim,no2_column
common /nlm_vars/ ascii,num_files
end module

!>  @brief
!>  Conversion program from ESRI or TOMS grid format to GrADs binary
!>  Create output file and write results in binary file and descriptor file
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  07/09/2020
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
program lee_satelite
  use variables
  implicit none

    call lee_namelist

    call procesa

    call crea_CTL

      contains
!>  @brief
!>  Lee ascii y los guarda en binario para GrADs
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  07/09/2020
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!>  @param i  counter for number_lon values
!>  @param j  counter for number_lat values
!>  @param irec record counter
!>  @param itim  time counter for files File_num
!>  @param cdum character dummy variable
!>  @param satelite_name nombre del formato ascii del satelite
subroutine procesa
integer :: i,j,irec,itim
character(len=10) :: cdum
character(len=20)::satelite_name

if (ascii.eq."ESRI") then
  satelite_name='omi_no2_2018.dat'
else
  satelite_name='tropomi_no2_2018.dat'
end if
  open (unit=8,file=satelite_name,FORM='UNFORMATTED',ACCESS='DIRECT'&
  &,RECL=4*number_lon*number_lat,convert='big_endian')
  irec=1
  do itim=1,num_files
     open (unit=10,file=cfile(itim))
          write(6,'(A,x,A)')' ** Reads File: ',cfile(itim)
      if(itim.eq.1) then
        read(10,'(A10)')cdum
      if(cdum(1:5).eq."ncols".and. ascii.eq."TOMS") then
          print *,"****  This file is ESRI format *****"
          print *,"  change ascii='ESRI' in satelite.nml"
          stop "Error 1 *****"
          else
            print *,ascii
        end if
        if(trim(cdum).eq."TROPOMI".and. ascii.eq."ESRI") then
          print *,"****  This file is TOMS format *****"
          print *,"  change ascii='TOMS' in satelite.nml"
          stop
        end if
        rewind (10)
      end if
  if (ascii.eq."ESRI") then
     do j=1,7
      read(10,'(A10)')cdum
     end do
     do j=1,number_lat
      read(10,*)(no2_column(i,j),i=1,number_lon)
     end do
    else
      do j=1,4
        read(10,'(A10)')cdum
      end do
      do j=1,number_lat
        read(10,'(A10)')cdum
        read(10,'(20I4)')(ino2_column(i,j),i=1,number_lon)
        do i=1,number_lon
          no2_column(i,j)=ino2_column(i,j)*1.0
        end do
      end do
    end if
     close(10)
     write(6,'(A,I4)')'  *** Stores time: ',itim
     write(8,rec=irec)((no2_column(i,j),i=1,number_lon),j=1,number_lat)
      irec=irec+1
    !no2_column=-999
  end do
  close(8)
deallocate(cfile)
end subroutine procesa
!>  @brief
!>  Lee archivo namelist satelite.nml y asigna los valores
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  07/09/2020
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!>  @param ascii formato de los datos TOMS o ESRI
!>  @param num_files Numero de archvios con promedios mensuales
!>  @param cfile file names array
!>  @param unit_nml unidad del archivo namelist
!>  @param existe boolena para saber si existe o no el satelite.nml
subroutine lee_namelist
    NAMELIST /formato_ascii/ ascii,num_files
    NAMELIST /archivos/ cfile
    integer unit_nml
    logical existe
    unit_nml = 9
    existe = .FALSE.
    write(6,*)' >>>> Reading file - satelite.nml'
    inquire ( FILE = './satelite.nml' , EXIST = existe )

    if ( existe ) then
    !  Opening the file.
    open ( FILE   = './satelite.nml' ,      &
    UNIT   =  unit_nml        ,      &
    STATUS = 'OLD'            ,      &
    FORM   = 'FORMATTED'      ,      &
    ACTION = 'READ'           ,      &
    ACCESS = 'SEQUENTIAL'     )
    !  Reading the file
    READ (unit_nml , NML = formato_ascii )
    allocate(cfile(num_files))
    READ (unit_nml , NML = archivos )
    close(unit_nml)
    else
    stop '***** No namelist_emis.nml in .. directory'
    end if

end subroutine lee_namelist
!>  @brief
!>  Crea el archivo descriptor de GrADs
!>   @author  Jose Agustin Garcia Reynoso
!>   @date  07/09/2020
!>   @version  1.0
!>   @copyright Universidad Nacional Autonoma de Mexico.
!>  @param name_ctl_file Nombre archivo CTL
subroutine crea_CTL
character(len=21):: name_ctl_file
      if(ascii.eq."ESRI") then
        name_ctl_file="omi_no2_2018.ctl"
      else
        name_ctl_file="tropomi_no2_2018.ctl"
      end if
      print *,'Creates ',name_ctl_file,'  file'
      open(unit=12,file=name_ctl_file)
      if(ascii.eq."ESRI") then
        write(12,200)
      else
        write(12,201)
      end if
      write(12,202)
      write(12,203)number_lon,lon_origin,cell_dim
      write(12,204)number_lat,lat_origin,cell_dim
      write(12,205)
      write(12,206)num_files
      write(12,207)
      write(12,208)
      write(12,209)
      close(12)
120   format(12000f7.0)
200   format('DSET ^omi_no2_2018.dat'/'Title NO2 total column molec10^15/cm^2 OMI'/'options big_endian yrev')
201   format('DSET ^tropomi_no2_2018.dat'/'Title NO2 total column molec10^13/cm^2 tropomi'/'options big_endian')
202   format('UNDEF -999')
203   format('xdef',I7,' linear ',f9.4,f12.7)
204   format('ydef',I7,' linear ',f9.4,f12.7)
205   format('zdef 1 linear 1 1')
206   format('tdef',I3,' linear 00z01jan2018 1mo')
207   format('vars 1')
208   format('    NO2 1 99  NO2 OMI total column ')
209   format('endvars')
end subroutine crea_CTL
end program lee_satelite
