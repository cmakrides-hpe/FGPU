program main

   use cudafor
   implicit none

!  Arguments

   integer    :: a, c, g
   integer    :: numa, numc, numg

   real, allocatable :: weight(:)
   real, allocatable :: phi(:,:)
   real, allocatable :: psi(:,:,:)

   numa = 64
   numc = 16000
   numg = 128

   allocate(weight(numa))
   allocate(phi(numg,numc))
   allocate(psi(numg,numc,numa))

   weight(:) = 1.0
   phi(:,:) = 2.0
   psi(:,:,:) = 3.0

!$omp target map(to:a,c,g,numa,numc,numg,weight,psi) map(tofrom:phi)
!$omp teams num_teams(numc) thread_limit(numg)
!$omp distribute parallel do collapse(2)
   do c=1,numc
    do g=1,numg
       do a=1,numa
         phi(g, c) = phi(g,c) + (weight(a) * psi(g,c,a))
       end do
     end do
   end do
!$omp end distribute parallel do
!$omp end teams
!$omp end target

   print *, "Sum: ", SUM(phi(:,:))
   return

end program main
