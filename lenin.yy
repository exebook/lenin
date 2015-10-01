≣ 'tokenize'

main ∆ {}

// SENTENCE
node ∆∅  name ∆[]  code ∆[]  when ∆[]  wait ∆[]  event ∆[]  exe ∆[]

// PARA

// PAGE
//============================================================//

➮ plus_op { $ ⚫a + ⚫b }
➮ literal_op { $ ⚫a }
➮ if_op { ⌥ ⚫a() { ⚫b() } }
➮ print_op { ロ ⚫a() ⦙ }
➮ greater_op { $ ⚫a > ⚫b }

wait1 ∆ []
➮ waitFor w {
	o ∆ { func: arguments.callee.caller, wait: w }
	wait1 ⬊ o
}

main.plus = ➮ {
	❶ a.prev.s  ❷ a.next.s
	node = a.next.next
	means(plus_op ꘉ {a:★①, b:★②})
}

main.symbol = ➮ {
	node = a.next.next
	means(literal_op ꘉ {a:'"'+ a.next.s +'"'})
} 

main.print = ➮print {
	⌥ codeꕉ {
		it_is(print_op ꘉ { a: codeꕉ })
	} ⎇ {
		waitFor('code')
	}
}

➮ then { codeꕉ = a ⦙ when ⬉ }
➮ it_is { codeꕉ = a }
➮ means { code ⬊ a }
➮ retwhen { when ⬊ a }

main.when = ➮ {
	⌥ whenꕉ && codeꕉ {
		then (if_op ꘉ { a:whenꕉ, b:codeꕉ })
		${}
	} ⎇ {
		$ { wait: 'when code' }
	}
}

main.greater = ➮ {
	x ∆ a.prev.s  y ∆ a.next.s
	cursor = a.next.next
	retwhen(greater_op ꘉ {a:x, b:y})
}

main.exit = ➮ { ⚑ }
main.it = ➮ it { }

main.dbg = ➮ dbg {
	ロ 'Debug code:', code
	ロ '         when:', when
	$ {}
}

main._sentence = ➮ _sentence {
	exe = exe ꗚ code
	code = []
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
		⌥ i ≟ 'code' && code↥ > 0
			{ $⦿ }
}

➮ checkActiveWaits {
	⌥ wait↥ ≟ 0 {$}
	
	wait = wait ꔬ (➮{
		⌥ !checkWait(a) { $⦿ }
		event ⬊ a.func
	})
}

➮ runFunction f node {
	r ∆ f(node)
	checkActiveWaits()
	wait = wait ꗚ wait1 ⦙ wait1 = []
}

main._undefined = ➮ {
	name ⬊ a.s
	${}
}

➮ mainLoop node {
	⧖ node {
		f ∆ main[node.s]
		⌥ f ≟ ∅ { f = main._undefined}
			runFunction(f, node)
			node = node.next
		⧖ event↥ > 0 {
			runFunction(event ⬉)
		}
	}
}

mainLoop(leninTokenize('''
	5 plus 7 print when 3 greater 2 dbg print when 5 plus 5 5 greater 2.
	print symbol hello.
'''))

/*
	10 plus 1 print.
	print symbol ok when 5 greater 2.
	5 greater 2 when print symbol ok.
	print 5 plus 50.
	print 1 plus 2 when 2 greater 1.
	symbol hello print.
*/
	
/*
	unknown words:
	sentence level: val
	para level: var
	page level: concept
	
*/
