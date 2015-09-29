≣ 'tokenize'

// PERMANENT
main ∆ {}

/*
*/

// SENTENCE
name ∆ []
what ∆ []
when ∆ []
wait ∆ []
event ∆ []
exe ∆ []

// PARA

// PAGE
//============================================================//

➮ plus_op {
	ロ '$plus', ꗌ (⚪)
	$ ⚫a + ⚫b
}

➮ literal_op {
	ロ '$literal'
	$ ⚫a
}

➮ if_op {
	ロ '$if'
	⌥ ⚫a() { ⚫b() }
//	⎇ ⚫c()
}

➮ print_op {
	ロ '$print:', ⚫a()
}

➮ greater_op {
	ロ '$greater', ⚫a, ⚫b
	$ ⚫a > ⚫b
}

➮ ret {
	❶ __argarr
	$ { f: main[① ⬉], args: ① }
}

main.plus = ➮ {
	❶ a.prev.s  ❷ a.next.s
//	$ ret('means', plus_op ꘉ {a:★①, b:★①}, next:a.next.next }
	$ { means: plus_op ꘉ {a:★①, b:★①}, next:a.next.next }
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

//print 2 when 3 greater 5

main.when = ➮ {
	⌥ whenꕉ && whatꕉ {
		$ ret('then', if_op ꘉ { a:whenꕉ, b:whatꕉ } )
	} ⎇ {
		$ { wait: 'when what' }
	}
}

main.greater = ➮ {
	x ∆ a.prev.s  y ∆ a.next.s
	ロ 'main.greater', x, y
	$ {
		next: a.next.next, 
		when: greater_op ꘉ {a:x, b:y}
	}
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
	ロ 'Sentence what:', what
	ロ '         when:', when
	exe = exe ꗚ what
	what = []
	wait = []
	${ }
}

main._para = ➮ _para {
	${ }
}

main._page = ➮ _page {
//	exe = exe ⫴ '\n'
	ロ 'Compiled script:\n'+color(4) + exe + color(7)+'\n'
	ロ 'Executing:'
	ロロ color(3)
	e ► exe {
		e()
	}
//	eval(exe)
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
		⌥ !checkWait(a) {$⦿}
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

➮ writeResult r {
//	⌥ r.it_is { whatꕉ = r.it_is }
	⌥ r.means { what ⬊ r.means }
	⌥ r.when { when ⬊ r.when }
//	⌥ r.then { whatꕉ = r.then, when ⬉ }
}

➮ runFunction f node {
	r ∆ f(node)
	⌥ r.f { r.f.apply(r, r.args) }
	writeResult(r)
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
			
		⌥ node ≟ ∅ {@}
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
	5 plus 5 print when 3 greater 2 dbg print when 5 plus 5 5 greater 2.
''')

mainLoop()

/*
	unknown words:
	sentence level: val
	para level: var
	page level: concept
	
*/
