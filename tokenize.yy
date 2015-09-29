➮ leninTokenizeOld str {
	str = repl(str, '\t', ' ')
	➮ nempty { ⌥(a↥ > 0) $a }
	R ∆ str ⌶ '\n' ꔬ (nempty)
	a ⬌ R {
		Rᵃ = Rᵃ ⌶ '.' ꔬ (nempty)
		P ∆ Rᵃ
		b ⬌ P {
			Pᵇ = Pᵇ ⌶ ' ' ꔬ (nempty)
		}
	}
	$ R
}

leninTokenize = ➮ leninTokenize str {
	str = repl(str, '\t', ' ')
	str = repl(str, '\r', '\n')
	str = repl(str, '\n\n', '\n')
	str = repl(str, '.', ' _sentence ')
	str = repl(str, '\n', ' _para ')
	➮ nempty { ⌥(a↥ > 0) $a }
	R ∆ str ⌶ ' ' ꔬ (nempty)
	⌥ (Rꕉ ≠ '_para') {
		ロ 'Fatal: There must be end-of-paragraph (CRLF) at the end of file.'
		⚑
	}
	⌥ (R[R↟-1] ≠ '_sentence') {
		ロ 'Fatal: last sentence must be terminated with dot.'
		⚑
	}
	R ⬊ '_page'
	X ∆ { s: R⁰ }
	root ∆ X
	i ⬌ R {
		⌥ (i ≟ 0) ♻
		o ∆ { s: Rⁱ, prev: X }
		X.next = o
		X = o
	}
	$ root
}

⌥ (process.argv¹ ≀ 'tokenize.yy' >= 0) {
	X ∆ leninTokenize('''
		a plus b. print it.
		exit.
	''')
	
	∞ {
		ロ X.s
		⌥ (X.next) X = X.next
		⎇ @
	}
}
⎇ {
}