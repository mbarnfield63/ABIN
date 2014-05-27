!initial version                         P. Slavicek a kol., Mar 25, 2009
!modifications                                          D.Hollas, 9.2.2012
!--------------------------------------------------------------------------
      SUBROUTINE shiftX (rx,ry,rz,px,py,pz,mass,dt)
      use mod_array_size
      use mod_general
      implicit none

      real*8 rx(npartmax,nwalkmax),ry(npartmax,nwalkmax),rz(npartmax,nwalkmax)
      real*8 px(npartmax,nwalkmax),py(npartmax,nwalkmax),pz(npartmax,nwalkmax)
      real*8 mass(npartmax,nwalkmax)
      real*8  :: dt
      integer :: i,iw

      do iw=1,nwalk
       do i=1, natom

         RX(i,iw) = RX(i,iw) + dt * PX(i,iw)/MASS(i,iw)
         RY(i,iw) = RY(i,iw) + dt * PY(i,iw)/MASS(i,iw)
         RZ(i,iw) = RZ(i,iw) + dt * PZ(i,iw)/MASS(i,iw)

       end do
      end do

      RETURN
      END


      SUBROUTINE shiftP (px,py,pz,fx,fy,fz,mass,dt)   !MASS IS NOT REALLY NEEDED
      use mod_array_size
      use mod_general
      implicit none

      real*8 px(npartmax,nwalkmax),py(npartmax,nwalkmax),pz(npartmax,nwalkmax)
      real*8 fx(npartmax,nwalkmax),fy(npartmax,nwalkmax),fz(npartmax,nwalkmax)
      real*8 mass(npartmax,nwalkmax) ! TODO get rid of this....
      real*8 dt
      integer :: i,iw

      do i=1, natom
       do iw=1,nwalk

         PX(I,iw) = PX(I,iw) + dt*FX(I,iw)
         PY(I,iw) = PY(I,iw) + dt*FY(I,iw)
         PZ(I,iw) = PZ(I,iw) + dt*FZ(I,iw)

       end do
      end do

      RETURN
      END
