module cumsum_mod

  implicit none

  integer, parameter :: dp = kind(1.0d0)

contains

  subroutine cumsum_do_loop(a,b)
    real(dp), intent(in) :: a(:)
    real(dp), intent(out) :: b(:)

    integer :: i

    b(1) = a(1)
    do i = 2, size(a)
      b(i) = b(i-1) + a(i)
    end do
  end subroutine

  subroutine cumsum_implied_do(a,b)
    real(dp), intent(in) :: a(:)
    real(dp), intent(out) :: b(:)
    integer :: i
    b = [(sum(a(1:i)), i = 1, size(a))]
  end subroutine

  subroutine cumsum_step_four(a, b)
    real(dp), intent(in) :: a(:)
    real(dp), intent(out) :: b(:)

    integer :: n, i, m

    n = size(a)
    m = n/4

    b(1) = a(1)
    b(1+m) = a(1+m)
    b(1+2*m) = a(1+2*m)
    b(1+3*m) = a(1+3*m)
    do i = 2, m
        b(i) = a(i) + b(i-1)
        b(i+m) = a(i+m) + b(i+m-1)
        b(i+2*m) = a(i+2*m) + b(i+2*m-1)
        b(i+3*m) = a(i+3*m) + b(i+3*m-1)
    end do

    ! Adjusting
    b(m+1:2*m) = b(m+1:2*m) + b(m)
    b(2*m+1:3*m) = b(2*m+1:3*m) + b(2*m)
    b(3*m+1:4*m) = b(3*m+1:4*m) + b(3*m)

    do i = 4*m+1, n
        b(i) = a(i) + b(i-1)
    end do
  end subroutine

  subroutine cumsum_step2(a, b)
    real(dp), intent(in) :: a(:)
    real(dp), intent(out) :: b(:)

    real(dp) :: s0, s1

    integer :: i, n

    s0 = 0.0_dp
    s1 = 0.0_dp

    n = size(a)

    do i = 1, n, 2
      block
        real(dp) :: x0, x1
        x0 = a(i)
        x1 = a(i+1)
        s0 = s1 + x0
        s1 = s1 + (x1 + x0)
        b(i) = s0
        b(i+1) = s1
      end block
    end do

    if (mod(n,2) /= 0) then
      b(n) = b(n-1) + a(n)
    end if
  end subroutine

  subroutine cumsum_step2_unroll(a, b)
    real(dp), intent(in) :: a(:)
    real(dp), intent(out) :: b(:)

    integer :: i, n
    ! integer :: rem

    n = size(a)

    b(1) = a(1)
    do i = 2, n, 3
        b(i) = a(i) + b(i-1)
        b(i+1) = a(i+1) + b(i)
        b(i+2) = a(i+2) + b(i+1)
    end do

    ! rem = mod(n,3)
    ! if (rem == 0) then
    !   b(n) = a(n) + b(n-1)
    ! else if (rem == 1) then
    !   b(n-1) = a(n-1) + b(n-2)
    !   b(n) = a(n) + b(n-1)
    ! end if

    do while(i < n)
      b(i) = b(i-1) + a(n)
      i = i + 1
    end do

  end subroutine

  subroutine cumsum_step3(a, b)
    real(dp), intent(in) :: a(:)
    real(dp), intent(out) :: b(:)

    real(dp) :: s0, s1, s2

    integer :: i, n, rem

    s0 = 0.0_dp
    s1 = 0.0_dp
    s2 = 0.0_dp

    n = size(a)

    do i = 1, n, 3
      block
        real(dp) :: x0, x1, x2
        x0 = a(i)
        x1 = a(i+1)
        x2 = a(i+2)
        s0 = s2 + x0
        s1 = s2 + (x1 + x0)
        s2 = s0 + (x2 + x1)

        b(i) = s0
        b(i+1) = s1
        b(i+2) = s2
      end block
    end do

    rem = mod(n,3)
    if (rem == 1) then
      b(n) = b(n-1) + a(n)
    else if (rem == 2) then
      b(n-1) = b(n-2) + a(n-1)
      b(n) = b(n-1) + a(n)
    end if

  end subroutine

end module


program main

  use iso_fortran_env, only: compiler_options, compiler_version
  use cumsum_mod
  implicit none

  integer :: n(4), ntrials, nreps

  ntrials = 7
  nreps = 1000
  n = [1000,10000,100000,1000000]

  write(*,*) '# Compiler version: ' // compiler_version()
  write(*,*) '# Compiler options: ' // compiler_options()


  write(*,*) '# do_loop'
  call run_test(ntrials,nreps,n,cumsum_do_loop)

  ! write(*,*) '# implied_do'
  ! call run_test(ntrials,100,n(1:3),cumsum_implied_do)

  write(*,*) '# step 2'
  call run_test(ntrials,nreps,n,cumsum_step2)

  write(*,*) '# step 2 unrolled'
  call run_test(ntrials,nreps,n,cumsum_step2_unroll)

  write(*,*) '# step 3'
  call run_test(ntrials,nreps,n,cumsum_step3)

  write(*,*) '# step four'
  call run_test(ntrials,nreps,n,cumsum_step_four)

contains

  subroutine run_test(ntrials,nreps,n,cumsum)
    integer, intent(in) :: ntrials, nreps
    integer, intent(in) :: n(:)
    interface
      subroutine cumsum(a,b)
        import dp
        real(dp), intent(in) :: a(:)
        real(dp), intent(out) :: b(:)
      end subroutine
    end interface

    real(dp), allocatable :: a(:), b(:)
    real(dp) :: start, end, elapsed(size(n))
    integer :: t, i, rep

    do t = 1, ntrials

      do i = 1, size(n)

        allocate(a(n(i)),b(n(i)))

        call random_number(a)

        call cpu_time(start)
          do rep = 1, nreps
            call cumsum(a,b)
          end do
        call cpu_time(end)
        elapsed(i) = end - start

        deallocate(a)
        deallocate(b)

      end do

      write(*,'(*(F9.3,:,1X))') million_doubles_per_sec(n,nreps,elapsed)

    end do

  end subroutine

  elemental function million_doubles_per_sec(n,nreps,elapsed) result(mdps)
    integer, intent(in) :: n, nreps
    real(dp), intent(in) :: elapsed
    real(dp) :: mdps

    mdps = (real(n,dp)/(elapsed/real(nreps,dp))) / 1.0e6_dp
  end function

end program