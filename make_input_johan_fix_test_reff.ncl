; 8.1.2015. Added git GH repo NCLscripts

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
begin



; Open the file
fin = addfile("/data/Download/les_model_output_3d/fielddump_hr02.nc","r")
; Get ql from the file
ql = fin->ql
ql = ql*1000. ; ql now in g/kg, original program uses g/m^3, which is approximately equal
;reff = fin->reff

pi=3.1415926
sig_g=1.34      ; standard deviation of cloud droplet size spectrum
sigfac=exp((log(sig_g))*exp(2))
;print (sigfac)
;rho=1.2920 ;this is in kg/m3 (at 0 deg C)
rho=1.2920*1.0e+3 ;this is in g/m3
;rhow=999.8395  ;this is in kg/m3 (at 0 deg C)
rhow=999.8395*1.0e+3  ;now it is in g/m3
;Nc_0=100000000.0 ;this is in m-3, or 100 cm-3
Nc_0=1.0e+8
;reff=1.0e-3*1.0e+6*sigfac*(3.*rho*ql/(4.*pi*rhow*Nc_0))^(1./3.)
;reff=1.0e+5*(3.*ql/(4.*pi*rho*Nc_0*0.67))^(1./3.)       ; igor, this is the one i last used
;reff=(3.*rho*ql/(4.*pi*rhow*Nc_0))*exp(1./3.)*sigfac
;ig, ovo je drugi nacin da izrazis R_eff, iz one idl skripte za konverziju.
g = ql*0. + 8.
rho_sca=1.0e+6
;N_sca=1.0e+8
N_sca=5.0e+7
fac=(g+2)*(g+1)*g
Rm=1.0e+6*(3.0*ql/(4.0*pi*rho_sca*N_sca*fac))^(1.0/3.0)
reff=4.0/3.0*(g+2)*Rm

; Determine number of gridboxes in each direction
dims = dimsizes(ql)
nx = dims(0)
ny = dims(1)
nz = dims(2)
; Carthesian coordinates (km)
x  = ql&x /1000.
y  = ql&y /1000.
z  = ql&z /1000.


do ii=8,1,1
  if (nx%ii.eq.0 .and. ny%ii.eq.0 .and. nz%ii.eq.0) then
    ncols = ii
    break
  end if
end do

xlines = floattointeger(nx/ncols)
ylines = floattointeger(ny/ncols)
zlines = floattointeger(nz/ncols)

x2d=onedtond(x,(/xlines,ncols/))
y2d=onedtond(y,(/ylines,ncols/))
z2d=onedtond(z,(/zlines,ncols/))

; P1,P2 and P3 are different outputs. ql is put in P1
rho_sca = 1.e6  ; g/m^3
N_sca   = 100e6 ; #/m^3 Cloud droplet number concentration, appropriate value for ASTEX

; I am not sure what these are for.
min_size = 0.
max_size = 10000.

; Format to be used to write values
fmt = "f9.5"

r=True
r@fout = "temp"
r@title = "-------"

;These outputs have proper grid order and variable values are centered :)
;foutname = "/data/LES/fielddump_hr02_rev_ecsimreff.dat"
foutname = "/data/LES/fielddump_hr18_N_50_ecsimreff.dat"
system("rm -rf "+foutname)
system("echo -e '\t'1'\t'"+nx+"'\t'"+ny+"'\t'"+nz+" > "+foutname)
system("rm -rf temp")
; The write_matrix method is fortran based. sprintf can also be used, which allows for leading zeros (and more).
; That method requires more work though.
write_matrix(x2d,ncols+fmt,r) 
system("cat temp >> "+foutname)
system("rm -rf temp")
write_matrix(y2d,ncols+fmt,r)
system("cat temp >> "+foutname)
system("rm -rf temp")
write_matrix(z2d,ncols+fmt,r)
system("cat temp >> "+foutname)
system("rm -rf temp")
system("echo -e -------'\n\t'"+sprintf("%8.1f",min_size)+"'\t'"+sprintf("%8.1f",max_size)+" >> "+foutname)

; Start of loop that puts the actual data to the output file.
g = ql*0. + 8.
delete(r@title)
data_out = new((/nz,3/),float)     ;creates a nz x 3 dimensional floar array, Igor comment
do ii=0,nx-1
  do jj=0,ny-1
;do ii=0,3
;  do jj=0,3
    system("echo -e -----ix="+(ii+1)+",iy="+(jj+1)+"----- >> "+foutname)
    data_out(:,0) = (/ql(ii,jj,:)/)
    data_out(:,1) = (/g(ii,jj,:)/)
    data_out(:,2) = (/reff(ii,jj,:)/)
    write_matrix(data_out,1+fmt+",f8.1,1"+fmt,r)
    system("cat temp >> "+foutname)
    system("rm -rf temp")
  end do
end do
end
