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
➮ result_op { $⚪ }
➮ plus_op { $ ⚫a + ⚫b }
➮ symbol_op { $ ⚫a }
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
	push('code', oper('symbol_op', symbol_op, {a:'"'+ a.next.s +'"'}))
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

main.sum = ➮ {
	⌥ !empty('all') {
		push('code', oper('sum_op', sum_op, { }) )
	} ⎇ {
		waitFor('all')
	}
	//
	➮ sum_op {
		n ∆ ∅
		i ► context.all ⌥ n ≟ ∅ {
			n = i()
		} ⎇ {
			n += i()
		}
		$ n
		push('code', oper('result', result_op, n))
	}
}

main.and = ➮ and {
	⌥ !empty('code') {
		⌥ empty('all') { waitFor('code') }
		push('all', pop('code'))
		clear('code')
	} ⎇ {
		ロ 'and: empty code'
		⚑
	}
}

//num 5 and num 7

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
	e ► context.exe {
		e()
	}
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

➮ stepDebug {
	⌥ context.code ↥ > 0 {
		i ► context.code
		ロロ'  '+i_+' '+color(6) +i.dbg+color(7)
	}
	⌥ context.when ↥ > 0 {
		ロロ '@'+color(2)+context.whenꕉ.dbg+color(7)
	}
}

➮ runFunction f node {
	⌥ node { ロロ '\n'+color(5)+ node.s +color(7) + ' '⦙ }
	f(node)
	stepDebug()
	checkActiveWaits()
	context.wait = context.wait ꗚ waitForQueue ⦙ waitForQueue = []
}

main._undefined = ➮ {
	push('token', a.s)
}

➮ mainLoop {
	node = a
	⧖ node {
		f ∆ main[node.s]
		⌥ f ≟ ∅ { f = main._undefined}
		runFunction(f, node)
		node = node.next
		⧖ event↥ > 0 {
			runFunction(event ⬉)
		}
	}
	ロ context.code
}

//	symbol abc and symbol qwe sum print.
mainLoop(leninTokenize('''
	str 'abc' length print.
	num 555 
'''))

/*

idea about *verbs and #nouns!

*concat #str #other-str | #str
*split str other-str | arr

Q: how to use same *length on str and arr?
*length str | num
*length arr | num
A: generalize via "type"
#list - can refer to str or arr or something else
*str 'abc' | #str='abc' #list='str' #item='str'
*num X | #num=X #item='num'

unknown words:
	word level: token
	sentence level: val
	para level: var
	page level: concept
	vlc dev 2349/774/27792
*/


