/*
	DEAR ME, ENABLE TDD PLEASE!! THANK YOU V.M.
*/

≣ 'tokenize'

main ∆ {}

// SENTENCE
node ∆∅	event ∆[]

context ∆ (➮ {
	R ∆ {
	}
	$ R
})()

// PARA

// PAGE
//============================================================//

➮ crash {
	ロ color(9) + 'Error: ' + __argarr ⫴ ' ' + color(7)
	⚑
}

➮ itemclear field other {
	flip ∆ ⦾
	⌥ field ≟ ∅ { field = context.item }
	⌥ context.other { flip = ⦿, context.other = ⦾ }
	⌥ other { flip = !flip }
	f ∆ field
	⌥ flip { f += '2' }
	contextᶠ = ∅
}

➮ itemset field value other {
	flip ∆ ⦾
	⌥ field ≟ ∅ { field = context.item }
	⌥ context.other { flip = ⦿, context.other = ⦾ }
	⌥ other { flip = !flip }
	f ∆ field
	⌥ flip { f += '2' }
	⌥ contextᶠ ≠ ∅ { crash('Redefining of ', field, 'is not allowed') }
	contextᶠ = value
}

➮ itemget field other {
	flip ∆ ⦾
	⌥ field ≟ ∅ { field = context.item }
	⌥ context.reverse { flip = !flip }
	⌥ other { flip = !flip }
	f ∆ field
	⌥ flip { f += '2' }
	$ contextᶠ
}

main['num'] = ➮ {
	node = node.next
	⌥ context.other {
		context.othernum = ★(node.s)
		context.other = ⦾
	}
	⎇ {
		setNum(★(node.s))
	}
}

main.str = ➮ {
	node = node.next
	itemset('str', node.s)
	context.item = 'str'
} 

main.other = ➮ {
	context.other = ⦿
}

/*

эх, во-первых реверс и озер это одно и тоже вышло.
во-вторых, допцстимо ли использовать itemget потом реверс а потом снова итемгет?
ведь это не декомпозится. то есть из конечного контекста предложения не удастся всё предложение восстановить. 
*/

main.each = ➮ {
	context.each = ⦿
}

main.print = ➮print {
	// prn[#item], ⌥ #each { n ► arr ロ n }, #each = ⦾
	⌥ context.each {
		context.each = ⦾
		arr ∆ context.arr
		n ► arr {
			ロ n_, n
		}
	}
	⎇ {
		item ∆ itemget()
		ロ item
	}
}

main.push = ➮ {
	⌥ context.list ≟ 'str' { context.str += itemGet() }
	⌥ context.list ≟ 'arr' { context.arr ⬊ itemGet() }
}

main.split = ➮ {
	context.arr = getItem('str') ⌶ getItem2('str')
	context.list = 'arr'
}

main.length = ➮ {
	setNum(context[context.list]↥)
}

main.concat = ➮ {
	tmp ∆ itemget('str') + itemget('str', ⦿)
	itemclear()
	itemset('str', tmp)
}

main.plus = ➮ {
	setNum(context.num + context.othernum)
}

main.item = ➮ {
	node = node.next
	context.item = node.s
}

main.list = ➮ {
	node = node.next
	context.list = node.s
}

main.pop = ➮ {
	node = node.next
//	⌥ context.list ≟ 'str' { ⌶⬈⫴ }
	⌥ context.list ≟ 'arr' {
		n ∆ context.arr ⬈
		⌥ ⬤n ≟ 'string' {
			context.item = 'str'
			context.str = n
		}
		⥹ ⬤n ≟ 'number' {
			context.item = 'num'
			context.num = n
		}
		context.arr ⬊ itemGet()
	}

	context.list = node.s
}

main._sentence = ➮ _sentence {
	context.other = ⦾
	context.each = ⦾
	context.list = ∅
}

main._para = ➮ _para {
	context.item = ∅
	context.num = ∅
	context.str = ∅
	context.arr = ∅
}

main._page = ➮ _page {
}

main._undefined = ➮ {
	ロ 'unkonw token', a
}

➮ mainLoop {
	node = a
	⧖ node {
		f ∆ main[node.s]
		⌥ f ≟ ∅ { f = main._undefined}
		f(node)
		node = node.next
	}
}

mainLoop(leninTokenize('''
	str a other str b concat print.
'''))

//	load from 'abc' then split by '\n'.
/*

override itemGet
	⌥ reverse otherGet
	  parent itemGet

override otherGet
	⌥ reverse itemGet
	  parent otherGet

-- *verbs, #nouns --

*other | #other=⦿
*concat #str #other-str | #str #item='str'
*split str other-str | arr=str⌶ot-str #list='arr'

*length str | num=#str↥ #item='num'
*length arr | num=#arr↥
#list - can refer to str or arr or something else
*str 'abc' | #<other>str='abc' #list='str' #item='str' #other=⦾
*num X | #<other>num=X #item='num' #other=⦾
*push | [#list] ⬊ [#item]
*each | #each = ⦿
*print | prn[#item], ⌥ #each { n ► arr ロ n }, #each = ⦾

*#other *concat *split *length *#list *#str *#num *push *#each *print *#item

unknown words:
	word level: token
	sentence level: val
	para level: var
	page level: concept
	
строка 111 а строка 222 склеить вывод. число 700 и число 77 плюс вывод. это строка вывод. это число вывод. строка 1-2-3-4-5 и строка - разбить это число .вложить все вывод.

это мега идея: каждый узел в семантическом контексте, может иметь имя или быть безымяным, однако, как только узел получает много связей, компилятор может начать выдавать варнинги: у вас сложная структура (узел) однако без имени, это плохо! при большой сложности узла может быть даже фатал-еррор.

Крутой пример лексообразования в фильме про тюрьму со шварцем и сталоне, где сталоне показывает шварцу повадки охранников, а шварц каждому из них даёт кличку на ходу.

*/


