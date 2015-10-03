≣ 'tokenize'

main ∆ {}

// SENTENCE
node ∆∅	event ∆[]

context ∆ (➮ {
	R ∆ {
		token: [], code: [], when: [], wait: [], exe: [],
	}
	$ R
})()

➮ last {
	⌥ b { (contextᵃ)ꕉ = b }
	⎇ $ (contextᵃ)ꕉ
}

➮ push {
	(contextᵃ) ≜ []
	contextᵃ ⬊ b
}

➮ clear {
	contextᵃ = []
}

➮ pop {
	$ contextᵃ ⬈
}

➮ empty {
	⌥ contextᵃ ≟ ∅ {$⦿}
	$ contextᵃ↥ ≟ 0
}

// PARA

// PAGE
//============================================================//
➮ oper name f _bind {
	f = f ꘉ _bind
	f.dbg = name
	$ f
}
➮ plus_op { $ ⚫a + ⚫b }
➮ literal_op { $ ⚫a }
➮ if_op {
	⌥ ⚫a() { ⚫b() }
}
➮ print_op {
	ロ ⚫a() ⦙
}
➮ greater_op { 
	$ ★(⚫a) > ★(⚫b)
}

waitForQueue ∆ []
➮ waitFor w {
	o ∆ { func: arguments.callee.caller, wait: w }
	waitForQueue ⬊ o
}

main.plus = ➮ {
	❶ a.prev.s  ❷ a.next.s
	node = a.next
	push('code', oper('plus_op', plus_op, {a:★①, b:★②}) )
}

main.symbol = ➮ {
	node = node.next
	push('code', oper('literal_op', literal_op, {a:'"'+ a.next.s +'"'}))
} 

main.print = ➮print {
	⌥ !empty('code') {
		last('code', oper('print_op', print_op, { a: last('code') }) )
	} ⎇ {
		waitFor('code')
	}
}

main.when = ➮ {
	⌥ !empty('when') && !empty('code') {
		last('code', oper('if_op', if_op, { a:last('when'), b:last('code') }) )
		pop('when')
	} ⎇ {
		waitFor('when code')
	}
}

main.greater = ➮ {
	x ∆ a.prev.s  y ∆ a.next.s
	cursor = a.next.next
	push('when', oper('greater_op', greater_op, {a:x, b:y}) )
}

main.load = ➮ {
	⛁ last('path')
	push('path')
	clear('path')
	push('code', pop('path'))
}

main.exit = ➮ { ⚑ }
main.it = ➮ it { }

main.dbg = ➮ dbg {
	ロ 'Debug code:', code
	ロ '         when:', when
}

main._sentence = ➮ _sentence {
	context.exe = context.exe ꗚ context.code
	context.code = []
	context.wait = []
}

main._para = ➮ _para {
}

main._page = ➮ _page {
	ロロ color(3)
	e ► context.exe { e() }
	ロ color(7)
}

➮ checkWait rec {
	i ► rec.wait ⌶ ' '
		⌥ i ≟ 'code' && context.code↥ > 0
			{ $⦿ }
}

➮ checkActiveWaits {
	⌥ empty('wait') {$}
	
	context.wait = context.wait ꔬ (➮{
		⌥ !checkWait(a) { $⦿ }
		event ⬊ a.func
	})
}

➮ runFunction f node {
	f(node)
	checkActiveWaits()
	context.wait = context.wait ꗚ waitForQueue ⦙ waitForQueue = []
}

main._undefined = ➮ {
	push('token', a.s)
}

➮ mainLoop {
	node = a
	⧖ node {
		⌥ node { ロ '\n@'+ node.s ⦙ }
		f ∆ main[node.s]
		⌥ f ≟ ∅ { f = main._undefined}
			runFunction(f, node)
			node = node.next
		⧖ event↥ > 0 {
			runFunction(event ⬉)
		}
		⌥ context.code ↥ > 0 {
			ロ 'code*'+context.code⁰.dbg
		}
		⌥ context.when ↥ > 0 {
			ロ 'when*'+context.when⁰.dbg
		}
	}
}

mainLoop(leninTokenize('''
	5 plus 7 print when 3 greater 2.
'''))

/*


unknown words:
	word level: token
	sentence level: val
	para level: var
	page level: concept
	
*/
