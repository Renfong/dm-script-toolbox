Image NumDerivative(Image src, number omega, number delta, number order){
	// Compute the 1st/2nd derivative by the
	//   5-point-stencil method
	Image rst := src.ImageClone()
	number scale0 = src.ImageGetDimensionScale(0)
	
	// apply low pass filter
	omega = round(omega/scale0)
	for (number idx=-omega; idx<=omega; idx++){
		rst += src[icol+idx, irow]
	}
	rst /= (2*omega+1)
	Image tmp := rst.ImageClone()
	
	// computing derivative
	delta = round(delta/scale0)
	if (order==1){
		// f'(x0) = (-f(x0+2h) + 8f(x0+h) - 8f(x0-h) + f(x0-2h)) / (12h)
		rst = -tmp[icol+2*delta,irow]+tmp[icol-2*delta,irow] \
				+8*tmp[icol+delta,irow]-8*tmp[icol-delta,irow]
		rst /= 6*delta
		rst.SetName(src.GetName()+"-diff1")
	}
	else {
		// f''(x0) = (-f(x0+2h) + 16f(x0+h) - 30f(x0) + 16f(x0-h) - f(x0-2h)) / (12h^2)
		rst = -tmp[icol+2*delta,irow]-tmp[icol-2*delta,irow] \
				+16*tmp[icol+delta,irow]+16*tmp[icol-delta,irow] \
				-30*tmp[icol,irow]
		rst /= 12*(delta**2)
		rst.SetName(src.GetName()+"-diff2")
	}
	
	return rst
}
