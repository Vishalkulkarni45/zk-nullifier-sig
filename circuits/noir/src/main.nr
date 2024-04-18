use dep::std;
use dep::curves::ecdsa_secp256k1::fp::PrimeField as fp;
use dep::curves::ecdsa_secp256k1::swcurve::{Curve,Point};
use dep::hash_to_curve::hash_to_curve;
use dep::biguint::{BigUint56, utils};
struct PlumeSignature {
      msg:[u8],
      pk:Field,
      nullifier:fp,
      //ensure c!=0 & s!=0
      c:fp,
      s:fp,
      v1specific:std::option::Option<PlumeSignatureV1Fields>
}

struct PlumeSignatureV1Fields{
    r_point:fp,
    hash_to_curve_r:fp
}

impl PlumeSignature {
    pub fn verify(self) {}
}

fn compress_point(x:fp,y:fp)->[u8;33] {
    let x_bytes= x.to_bytes();

    // Assuming x.to_bytes() returns an array of 35 bytes
    let mut rev_x = [0 as u8; 32];
    // Initialize rev_x
    for i in 0..32 {
        rev_x[i] = x_bytes[31 - i]; // Reverse the first 32 bytes of x_bytes into rev_x
    }
    let two = BigUint56::from_u56(2);

    //TODO : do direct modulus
    let is_y_odd= if y.to_biguint56().addmod(BigUint56::zero(), two).eq(BigUint56::one()) {
        BigUint56::from_u56(3)
    } else {
        BigUint56::from_u56(2)
    };
    let mut compressed_point= [0 as u8; 33];
    compressed_point[0]=is_y_odd.to_bytes()[0];
    for i in 1..33 {
        compressed_point[i]=x_bytes[i-1];
    }
    compressed_point
}
fn main(msg: Field, pk: pub Field) {}

#[test]
fn test_compress_point() {
    //jacobian form
    let spec256_curve= Curve::new(fp::zero(), fp::from_u56(7), Point::from_affine(
            fp::from_bytes([0x98, 0x17, 0xf8, 0x16, 0x5b, 0x81, 0xf2, 0x59, 0xd9, 0x28, 0xce, 0x2d, 0xdb,
                    0xfc, 0x9b, 0x02, 0x07, 0x0b, 0x87, 0xce, 0x95, 0x62, 0xa0, 0x55, 0xac, 0xbb,
                    0xdc, 0xf9, 0x7e, 0x66, 0xbe, 0x79]), fp::from_bytes([0xb8, 0xd4, 0x10, 0xfb, 0x8f, 0xd0, 0x47, 0x9c, 0x19, 0x54, 0x85, 0xa6, 0x48,
                    0xb4, 0x17, 0xfd, 0xa8, 0x08, 0x11, 0x0e, 0xfc, 0xfb, 0xa4, 0x5d, 0x65, 0xc4,
                    0xa3, 0x26, 0x77, 0xda, 0x3a, 0x48])
        ));

    //std::println(spec256_curve);
    //jacobin form (X,Y,Z)
    let point = Point::from_affine(
        fp::from_bytes([0x98, 0x17, 0xf8, 0x16, 0x5b, 0x81, 0xf2, 0x59, 0xd9, 0x28, 0xce, 0x2d, 0xdb, 0xfc,
                0x9b, 0x02, 0x07, 0x0b, 0x87, 0xce, 0x95, 0x62, 0xa0, 0x55, 0xac, 0xbb, 0xdc, 0xf9,
                0x7e, 0x66, 0xbe, 0x79]), fp::from_bytes([0xb8, 0xd4, 0x10, 0xfb, 0x8f, 0xd0, 0x47, 0x9c, 0x19, 0x54, 0x85, 0xa6, 0x48, 0xb4,
                0x17, 0xfd, 0xa8, 0x08, 0x11, 0x0e, 0xfc, 0xfb, 0xa4, 0x5d, 0x65, 0xc4, 0xa3, 0x26,
                0x77, 0xda, 0x3a, 0x48])
    );
    std::println(point);
    let (x,y)= point.to_affine();
    let compressed_point= compress_point(x, y);
}
