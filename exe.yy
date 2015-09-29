// This is an older version of lenin, that generates output as a string.
// I decided to give a try to a functional output, so this became obsolete.
// But it remains to be seen which way is better.

≣ 'tokenize'

// PERMANENT
main ∆ {}

// SENTENCE
name ∆ []
what ∆ []
when ∆ []
wait ∆ []
event ∆ []

// PARA

// PAGE
exe ∆ []

//============================================================//

main.plus = ➮ {
	x ∆ a.prev.s  y ∆ a.next.s
	$ { means: x + ' + ' + y, next:a.next.next }
}

main.symbol = ➮ {
	$ { means: '"'+ a.next.s +'"', next: a.next }
} 

main.print = ➮print {
	⌥ whatꕉ {
		$ { it_is: 'console.log(' + whatꕉ + ')' }
	} ⎇ {
		$ { wait: 'what' }
	}
}

//print 2 when 3 greater 5

main.when = ➮ {
	⌥ whenꕉ && whatꕉ {
		w ∆ 'if(' + whenꕉ + ') ' + whatꕉ
		$ { then: w }
	} ⎇ {
		$ { wait: 'when what' }
	}
}

main.greater = ➮ {
	x ∆ a.prev.s  y ∆ a.next.s
	$ {
		next: a.next.next, 
		when: '(' + x + ' > ' + y + ')'
	}
}

main.exit = ➮ {
	⚑
}

main.it = ➮ it {
	
}

main._sentence = ➮ _sentence {
	ロ 'Sentence what:', what
	ロ '         when:', when
	exe ⬊ [what⫴'\n']
	what = []
	wait = []
	${ }
}

main._para = ➮ _para {
	${ }
}

main._page = ➮ _page {
	exe = exe ⫴ '\n'
	ロ 'Compiled script:\n'+color(4) + exe + color(7)+'\n'
	ロ 'Executing:'
	ロロ color(3)
	eval(exe)
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

➮ writeResult r {
	⌥ r.it_is { whatꕉ = r.it_is }
	⌥ r.means { what ⬊ r.means }
	⌥ r.when { when ⬊ r.when }
	⌥ r.then { whatꕉ = r.then, when ⬉ }
}

➮ runFunction f node {
	r ∆ f(node)
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
*/
	
node ∆ leninTokenize('''
	print 5 plus 50.
	print 1 plus 2 when 2 greater 1.
	symbol hello print.
''')

mainLoop()

/*
	unknown words:
	sentence level: val
	para level: var
	page level: concept
	
*/
