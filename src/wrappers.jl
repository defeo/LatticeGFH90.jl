##########################################################
#
# Wrappers for C code
#
##########################################################

function _solve_h90(A::tensor_algebra)
    res = A()
    ccall((:solve_h90, :libembed), Nothing, (Ref{fq_nmod_poly},
          Ref{FqNmodFiniteField}, Ref{FqNmodFiniteField}), res.elem, A.L, A.R)
    return res
end

function lift_h90(x::fq_nmod, A::tensor_algebra)
    res = A()
    ccall((:lift_h90, :libembed), Nothing, (Ref{fq_nmod_poly},
          Ref{fq_nmod}, Ref{FqNmodFiniteField}, Ref{FqNmodFiniteField}),
          res.elem, x, A.L, A.R)
    return res
end

function minpoly(x::fq_nmod)
    result = PolynomialRing(ResidueRing(ZZ, Int(characteristic(parent(x)))), "T")[1]()
    ccall((:minpoly, :libembed), Nothing, (Ref{nmod_poly}, Ref{fq_nmod}, 
          Ref{FqNmodFiniteField}), result, x, parent(x))
    return result
end

function nth_root2(x::fq_nmod, n::Int)
    F = parent(x)
    y = F()
    ccall((:nth_root, :libembed), Nothing, (Ref{fq_nmod}, Ref{fq_nmod}, UInt,
          Ref{FqNmodFiniteField}), y, x, UInt(n), F)
    return y
end

function linfactor(x::fq_nmod_poly)
    R = parent(x)
    y = R()
    ccall((:linfactor, :libembed), Nothing, (Ref{fq_nmod_poly},
          Ref{fq_nmod_poly}, Ref{FqNmodFiniteField}), y, x, base_ring(R))
    return y
end

function change_basis_inverse(toK::FqNmodFiniteField, a::fq_nmod, g::fq_nmod)
    fromL = parent(a)
    res = toK()
    ccall((:change_basis_inverse, :libembed), Nothing, (Ref{fq_nmod},
          Ref{fq_nmod}, Ref{fq_nmod}, Ref{FqNmodFiniteField},
          Ref{FqNmodFiniteField}), res, a, g, fromL, toK)
    return res
end

function change_basis_direct(a::fq_nmod, g::fq_nmod)
    fromK = parent(a)
    toL = parent(g)
    res = toL()
    ccall((:change_basis_direct, :libembed), Nothing, (Ref{fq_nmod},
          Ref{fq_nmod}, Ref{FqNmodFiniteField}, Ref{fq_nmod},
          Ref{FqNmodFiniteField}), res, a, fromK, g, toL)
    return res
end

function import_conway(p::Int, d::Int)
    poly = PolynomialRing(ResidueRing(ZZ, p), "T")[1]()
    b = ccall((:import_conway, :libembed), Bool, (Ref{nmod_poly}, Ref{fmpz},
              UInt), poly, ZZ(p), d)
    return b, poly
end

function change_basis_prepare(toK::FqNmodFiniteField, g::fq_nmod)
    fromL = parent(g)
    deriv_inv = toK()
    trace_one = fromL()
    ccall((:change_basis_prepare, :libembed), Nothing, (Ref{fq_nmod},
          Ref{fq_nmod}, Ref{fq_nmod}, Ref{FqNmodFiniteField},
          Ref{FqNmodFiniteField}), deriv_inv, trace_one, g, fromL, toK)
    return deriv_inv, trace_one
end

function change_basis_inverse_precomp(a::fq_nmod, g::fq_nmod,
                                      deriv_inv::fq_nmod, trace_one::fq_nmod)
    fromL = parent(a)
    toK = parent(deriv_inv)
    res = toK()
    ccall((:change_basis_inverse_precomp, :libembed), Nothing, (Ref{fq_nmod},
          Ref{fq_nmod}, Ref{fq_nmod}, Ref{FqNmodFiniteField},
          Ref{FqNmodFiniteField}, Ref{fq_nmod}, Ref{fq_nmod}), res, a, g, fromL,
          toK, deriv_inv, trace_one)
    return res
end

function fit_length!(x::fq_nmod, n::Int)
    ccall((:nmod_poly_fit_length, :libflint), Nothing, (Ref{fq_nmod}, Int), x, n)
end

function normalize!(x::fq_nmod)
    ccall((:_nmod_poly_normalise, :libflint), Nothing, (Ref{fq_nmod},), x)
end
