program main
   use particle
   implicit none

   ! define variables
   type(par) :: p
   real :: E(3),B(3),E_value, B_value,n
   real :: dt
   integer :: time, iostatus,i
   logical :: input_validation=.TRUE., s=.TRUE.
   character(30), dimension(6) :: values
   dt = 1e-10 !timestep
   
   ! reading the values of E, B, m, q from the file
   open(unit=10,file='data.dat',status='old', action='read')

   do i=1,4
      read(10,'(A)') values(i)
   end do

   close(unit=10)

   ! change strings to real numbers
   read(values(1)(5:),*) E_value
   read(values(2)(5:),*) B_value !theoretical ideal for B is 0.4147408125
   read(values(3)(5:),*) p%m
   read(values(4)(5:),*) p%q

   ! PART 1 ---------------------------------------------------------------------------------------------------------------------------------------------------------
   ! ask user for the time of the measurement (ask for integer, number of miliseconds)
   !write(*,'(A)') 'Please provide the time of the measurment in miliseconds as an integer:'

   ! this checks if the user gave valid input and asks for new if it is not right
   !do while (input_validation)
      !read(*,*,iostat=iostatus) time

      !if (iostatus /= 0) then
         !write(*,'(A)') 'Invalid input. Please enter an integer.'
      !else
         !input_validation=.FALSE.
      !end if
   !end do

   ! set values of initial position and initial velocity (think of reading x,v,a from the file)
   !p%pos = [0.0,1.5,0.0] !assuming we do not start from origin of the coordinate system k(otherwise E=0 and no movement appears)
   !p%v = [0,0,0] !assuming no initial velocity
   !p%a = [0,0,0] !assuming no initial acceleration
   
   ! initial set E and B vectors
   !E = -E_value/(sqrt(sum(p%pos**2)))*p%pos !we assume the E always go to the center so that E vector is always the negative of position
   !B = B_value*[0,0,1]

   ! initial time, position and velocity printed out
   !write(*,'(A,I5,A)') 'Time:',0,'ns'
   !write(*,'(A,X,G10.4,X,G10.4,X,G10.4,X,A)') 'Position:',p%pos,'m'
   !write(*,'(A,X,G10.4,X,G10.4,X,G10.4,X,A)') 'Velocity:',p%v,'m/s'
   !write(*,*)

   ! the time step
   !do i=1,time*10000000
      !call step(p,E,B)
      !E = -E_value*p%pos
      !if (mod(i,10000000)==0) then ! every 1ms orint out
         !write(*,'(A,I6,A)') 'Time:',i/10000000,'ms'
         !write(*,'(A,X,G12.4,X,G12.4,X,G12.4,X,A)') 'Position:',p%pos,'m'
         !write(*,'(A,X,G12.4,X,G12.4,X,G12.4,X,A)') 'Velocity:',p%v,'m/s'
         !write(*,*)
      !end if
   !end do
   !---------------------------------------------------------------------------------------------------------------------------------------------
   
   ! set values of initial position and initial velocity (think of reading x,v,a from the file)
   p%pos = [1.5,0.,0.] !assuming we DONT start from origin of the coordinate system k(otherwise E=0 and no movement appears)
   !p%v = [0.,-sqrt(2*1.9226119608e-12/p%m),0.] !PART 2
   p%a = [0.,0.,0.] !assuming no initial acceleration
    
   !PART 3
   p%pos = [0.0,-1.5,0.0] !we start from the last positon from magnet in part 4
   ! velocity in x direction from K (in part 4 it must be final v of magnet)
   velocity=sqrt(2*12*1e6*1.6022*1e-19/p%m)
   p%v = [-velocity,0.0,0.0] !assuming initial velocity such that K=12 MeV

   ! initial set E and B vectors
   !PART 1 E = -E_value*p%pos/norm2(p%pos) !we assume the E alwayjs go to the center so that E vector is always the negative of position
   B = B_value*[0,0,1]

   !PART 3
   E = E_value*([0.0,-2.7,0.0]-p%pos)/(sqrt(sum([0.0,-2.7,0.0]-p%pos)**2))

   ! PART 2
   ! the time step
   !time = time * 1000000000
   !open(unit=1,file="p2_1_B=0.6.dat",status="replace")
   !do i=1,time
      !call step(p,E,B)
      !E = -E_value*p%pos/norm2(p%pos)
      !if (norm2(p%pos)<=1.45 .or. norm2(p%pos)>=1.55) then
         !print *,"hit the wall"
         !exit
      !end if
      !if (p%pos(1)<=0.) then
         !print *,"successful"
         !exit
      !end if
      !if (mod(i,5)==0) then
         !write(*,*) 'Position:',p%pos, norm2(p%pos)!,'E:',E ! the input time must be quite large to notice change of position and E
         !write(1,*) p%pos(1)," ",p%pos(2)
      !end if
   !end do
   !close(1)

! PART 3
! time step 
   n=0.523598776 ! 30 deg
   v=([0.0,-2.7,0.0]-p%pos) !vector from position to the centre of filter

   open(unit=10, file='data2.dat', status='replace', action='write') !change to file 1 or 3 depending on which E you try
   do while (s)
      write(10,*) p%pos(1),';',p%pos(2)
      call step(p,E,B)
      v=([0.0,-2.7,0.0]-p%pos)
      E = E_value*v/(sqrt(sum(v)**2))
      if (norm2(v)>=1.21 .or. norm2(v)<=1.19 .or. atan(v(1)/(-v(2)))<0) then ! hits the walls
         s=.FALSE.
         write(*,*) 'wall'
         write(10,*) p%pos(1),';',p%pos(2)
         
      else if (atan(v(1)/(-v(2)))>=n) then !arctan(x/y), reaches the end of filter
         s=.FALSE.
         write(*,*) 'the end of filter'
         write(10,*) p%pos(1),';',p%pos(2)
      end if
   end do
   close(unit=10)
   
end program main
