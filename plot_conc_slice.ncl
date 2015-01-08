load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"   
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"   
; ================================================;
begin
;=================================================;
; open file and read in data
;fin = addfile("nws_precip_conus_20110101.nc","r")
;fin = addfile("/data/ECSIMv15/sessions/Radar.20110721151933318/0-Radar/radar_output.nc","r")
fin = addfile("drop_siz_conc_rev.nc","r")
;fin = addfile("/data/ECSIMv15/sessions/Radar.20110809141708837/0-Radar/lwp.nc","r")
;fin = addfile("/data/ECSIMv15/sessions/Radar.20110816131859358/0-Radar/reff_slice_rev.nc","r")
;fin = addfile("/data/ECSIMv15/sessions/Radar.20110817103245279/0-Radar/reff_slice_rev.nc","r")
; Get data from the file
conc = fin->N_0
;print (conc)
print (max(conc))
conc=conc/100000000.0
wks  = gsn_open_wks("ps","conc_ncl_hr18_ncl")    ; open a PS file
;wks  = gsn_open_wks("x11","effective_radius")    ; open an X-window file

; these 3 lines plot the figure rotated by 90 degs anti-clockwise
;wks_type = "ps"
;wks_type@wkOrientation = "landscape"
;wks = gsn_open_wks(wks_type,"reff_ncl") 

gsn_define_colormap(wks,"gui_default")   ; choose a colormap
;gsn_define_colormap(wks,"rainbow")


; Set up resources.

  res                     = True         ; plot mods desired
  res@vpXF = 0.14
  tfPlotManagerOn         = True         ;ig  

;  res@trYMinF = 1.0
;  res@trYMaxF = 1.0
  
  res@cnFillOn            = True          ; turn on color
  res@gsnSpreadColors     = True          ; use full range of colormap
  res@cnLinesOn           = False         ; no contour lines
  res@gsnMaximize         = True          ; maximize plot
  
;With these you can set up MIN & MAX values plotted, as well as the levels between the contoures.  
  
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = 0.0                 ; set min contour level
  res@cnMaxLevelValF       = 24.5                 ; set max contour level
  res@cnLevelSpacingF = 0.2
  
;Control over the color bar and the labels  
  
  res@lbAutoManage          = False             ; we control label bar
;  res@pmLabelBarDisplayMode = "Always"          ; turns on label bar
  res@lbOrientation         = "Horizontal"      ; ncl default is vertical
  res@pmLabelBarSide        = "Bottom"          ; default is right
  res@lbLabelStride         = 20                 ; skip every other label
  res@pmLabelBarWidthF      = 0.9               ; default is shorter
  res@pmLabelBarHeightF     = 0.3               ; default is taller
  res@lbLabelFontHeightF    = .18              ; default is HUGE
  res@lbPerimOn             = False             ; default has box




  res@gsnDraw             = False         ; don't draw
  res@gsnFrame            = False         ; don't advance frame
  res@vpWidthF            = 1.0           ; change aspect ratio of plot, bilo 0.5
  res@vpHeightF           = 1.0           ; bilo 0.3
  res@lbLabelFontHeightF  = 0.02            ; make labels smaller
  res@tiXAxisString       = "km"            ; X axis Label
  res@tiYAxisString       = "km"            ; X axis Label
  
  res@tmXBMode             = "Explicit"     ; Explicitly set labels for X axis.
  res@tmXBValues           = (/100,200,300,400,500/)
  res@tmXBLabels           = (/"5", "10", "15", "20", "25"/)
  
  res@tmYLMode             = "Explicit"     ; Explicitly set labels for Y axis.
  res@tmYLValues           = (/10,20,30/)
  res@tmYLLabels           = (/"0.5", "1.0", "1.5"/)


;res@tmYLMode             = "Manual"   ; Manually set tickmarks on Y axis
;  res@tmYLTickSpacingF     = 15.         ; Only set spacing, not start/end
;  res@tmYBValues           = (/2,4,6,8,10,12,14,16,18,20,22,24/)

  
  plot = gsn_csm_contour(wks,conc,res)      ; contour the variable
;   plot = gsn_csm_y(wks,conc,res)      ; scatter plot

;************************************************
; create panel
;************************************************
  resP            = True                         ; modify the panel plot
; resP@txString   = "A common title"
  resP@txString   = "ecsim_hr18_conc"
;  resP@gsnPanelLabelBar    = True                ; add common colorbar
  resP@lbLabelFontHeightF  = 0.00013               ; make labels smaller
  gsn_panel(wks,plot,(/1,1/),resP)               ; now draw as one plot


    
    
end
