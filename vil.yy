context = {}

➮ findName {
	⌥ ⬤a ≠ 'object' {
		$ findName(context, a)
	}
	⌥ aᵇ { $a }
	⧗ (∇ i in a) {
		⌥ ⬤aⁱ ≟ 'object' {
			t ∆ findName(aⁱ, b)
			⌥ t && tᵇ { $t }
		}
	}
}

➮ stroi {
	A ∆ __argarr
	o ∆ context
	⧗(i ∆ 0; i < A↥-1; i++) {
		n ∆ A[i]
		⌥ o[n] ≟ ∅ { o[n] = {} }
		o = o[n]
	}
	$ o
}

 x = 1
 a b = 2
//ロ a
//ロ x
//ロ a b
//ロ .b
//ロ context
//
ロ 'find a =', findName('a')
ロ 'find b =', findName('b')
ロ 'find c =', findName('c')
ロ 'find x =', findName('x')

$

W ∆ 50   H ∆ 20

/*
def setPixel
	screenˣʸ = color
	
def rect
	⧗ (a ∆ y; a < y+h; a++)
	⧗ (b ∆ x; b < x+w; b++)
		setPixel
*/

screen = []

➮ initScreen {
	⧗(a ∆ 0; a < H; a++) {
		screenᵃ = []
	}
}

➮ setPixel {
	x = 1
	y = 2
	ロ  x,  y
	screen[ x][y] = color
}

➮ rect {
//	⧗ (y ∆ rect y; y < y+h; y++)
//	⧗ (x ∆ rect x; x < x+w; x++)
		setPixel
}

a = 5 + 6
stroi('a', 5+6)

//initScreen()
color = 10
rect x = 5
rect y = 5
//
//rect()
//ロ screen
ロ context
