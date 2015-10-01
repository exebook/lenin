/*
	This is obsolete (maybe temporary obsolete) approach.
	I think it is better to simply modfy "global" context graph,
	rather than trying to be functionally pure.
*/
≣ 'tokenize'

main ∆ {}

// SENTENCE
name ∆ []  what ∆ []  when ∆ []  wait ∆ []  event ∆ []  exe ∆ []

// PARA

// PAGE
//============================================================//

➮ plus_op {
	$ ⚫a + ⚫b
}

➮ literal_op {
	$ ⚫a
}

➮ if_op {
	⌥ ⚫a() { ⚫b() }
}

➮ print_op {
	ロ ⚫a()
}

➮ greater_op {
	$ ⚫a > ⚫b
}

➮ ret {
	❶ __argarr  ❷ ∅
	⌥ ⬤(①⁰) ≠ 'string' { ② = ① ⬉ }
	$ { f: main[① ⬉], args: ①, next: ② }
}

main.plus = ➮ {
	❶ a.prev.s  ❷ a.next.s
	$ ret(a.next.next, 'means', plus_op ꘉ {a:★①, b:★②})
}

main.symbol = ➮ {
	$ { means: literal_op ꘉ {a:'"'+ a.next.s +'"'}, next: a.next }
} 

main.print = ➮print {
	⌥ whatꕉ {
		$ ret('it_is', print_op ꘉ { a: whatꕉ })
	} ⎇ {
		$ { wait: 'what' }
	}
}

main.when = ➮ {
	⌥ whenꕉ && whatꕉ {
		$ ret('then', if_op ꘉ { a:whenꕉ, b:whatꕉ } )
	} ⎇ {
		$ { wait: 'when what' }
	}
}

main.greater = ➮ {
	x ∆ a.prev.s  y ∆ a.next.s
	$ ret(a.next.next, 'retwhen', greater_op ꘉ {a:x, b:y})
}

main.exit = ➮ {
	⚑
}

main.it = ➮ it {
	
}

main.dbg = ➮ dbg {
	ロ 'Debug what:', what
	ロ '         when:', when
	$ {}
}

main._sentence = ➮ _sentence {
	exe = exe ꗚ what
	what = []
	wait = []
	${ }
}

main._para = ➮ _para {
	${ }
}

main._page = ➮ _page {
	ロロ color(3)
	e ► exe { e() }
	ロ color(7)
	${}
}

➮ checkWait rec {
	i ► rec.wait ⌶ ' '
		⌥ i ≟ 'what' && what↥ > 0
			{ $⦿ }
}

➮ checkActiveWaits {
	⌥ wait↥ ≟ 0 {$}
	
	wait = wait ꔬ (➮{
		⌥ !checkWait(a) { $⦿ }
		event ⬊ a.func
	})
}

➮ recordWaits f w args {
	⌥ w {
		o ∆ { func: f, wait: w, args: args }
		wait ⬊ o
	}
}

main.it_is = ➮ it_is {
	whatꕉ = a
}

main.then = ➮ then {
	whatꕉ = a
	when ⬉
}

main.means = ➮ means {
	what ⬊ a
}

main.retwhen = ➮ {
	when ⬊ a
}

➮ runFunction f node {
	r ∆ f(node)
	⌥ r.f { r.f.apply(r, r.args) }
	checkActiveWaits()
	recordWaits(f, r.wait, r.args)
	$ r.next
}

➮ mainLoop {
	⧖ node {
		f ∆ main[node.s]
		⌥ f ≠ ∅ {
			n ∆ runFunction(f, node)
			⌥ n { node = n }
			⎇ node = node.next
		} ⎇ {
			name ⬊ node.s
			node = node.next
		}
		⧖ event↥ > 0 {
			runFunction(event ⬉)
		}
	}
}

/*
	10 plus 1 print.
	print symbol ok when 5 greater 2.
	5 greater 2 when print symbol ok.
	print 5 plus 50.
	print 1 plus 2 when 2 greater 1.
	symbol hello print.
*/
	
node ∆ leninTokenize('''
	5 plus 7 print when 3 greater 2 dbg print when 5 plus 5 5 greater 2.
''')

mainLoop()

/*
	unknown words:
	sentence level: val
	para level: var
	page level: concept
	
*/
