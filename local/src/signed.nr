use dep::std;

// See https://github.com/SleepingShell/noir-signed for tests

struct Signed {
    x: u124,
    is_neg: bool,
}

impl Signed {
    fn add(self, other: Self) -> Self {
        let mut val: u124 = 0;
        let mut is_neg = false;

        if (!(self.is_neg ^ other.is_neg)) { //if signs are the same
            val = self.x + other.x;
            is_neg = self.is_neg;
        } else {
            if (self.x > other.x) {
                val = self.x - other.x;
                is_neg = self.is_neg;
            } else {
                val = other.x - self.x;
                is_neg = other.is_neg;
            }

            if (val == 0) {
              is_neg = false;
            }
        }

        Self {
            x: val,
            is_neg: is_neg,
        }
    }

    fn sub(self, other: Self) -> Self {
        self.add(other.flip())
    }

    fn mul(self, other: Self) -> Self {
        let val = self.x * other.x;
        let mut is_neg: bool = false;
        if (val != 0) {
            is_neg = self.is_neg ^ other.is_neg;
        }

        Self {
            x: val,
            is_neg: is_neg,
        }
    }

    fn div(self, other: Self) -> Self {
        let val = self.x / other.x;
        let mut is_neg: bool = false;
        if (val != 0) {
            is_neg = self.is_neg ^ other.is_neg;
        }

        Self {
            x: val,
            is_neg: is_neg,
        }
    }

    fn muli(self, other: u124) -> Self {
        Self {
            x: self.x * other,
            is_neg: self.is_neg,
        }
    }

    fn eq(self, other: Self) -> bool {
        (self.x == other.x) & (self.is_neg == other.is_neg)
    }

    fn squared(self) -> Self {
        Self {
            x: self.x * self.x,
            is_neg: false,
        }
    }

    fn flip(self) -> Self {
        Self {
            x: self.x,
            is_neg: !self.is_neg & (self.x != 0),
        }
    }

    fn abs(self) -> Self {
        Self {
            x: self.x,
            is_neg: false,
        }
    }

    fn absi(self) -> u124 {
        self.x
    }

    fn zero() -> Self {
        Self {
            x: 0,
            is_neg: false,
        }
    }

    fn to_signed(val: u124) -> Self {
        Self {
            x: val,
            is_neg: false,
        }
    }
}