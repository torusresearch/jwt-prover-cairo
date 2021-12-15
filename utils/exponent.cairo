from starkware.cairo.common.math import unsigned_div_rem
func exponent{range_check_ptr}(x, n) -> (res):
    if n == 0:
        return (res=1)
    end
    
    let (q,r) = unsigned_div_rem(n,2)
    if r == 0:
        let (m) = exponent(x, n/2)
        return(res=m * m)
    else:
        let (m) = exponent(x=x, n=n-1)
        return (res=x * m)
    end
end