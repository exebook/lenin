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

➮ setNum {
	context.num = a
	context.item = 'num'
}

➮ setStr {
	context.str = a
	context.item = 'str'
	context.list = 'str'
}

➮ getItem {
	$ context[context.item]
}

main.num = ➮ {
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
	⌥ context.other {
		context.otherstr = node.s
		context.other = ⦾
	}
	⎇ {
		setStr(node.s)
	}
} 

main.other = ➮ {
	context.other = ⦿
}

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
		item ∆ context[context.item]
		ロ item
	}
}

main.push = ➮ {
	⌥ context.list ≟ 'str' { context.str += getItem() }
	⌥ context.list ≟ 'arr' { context.arr ⬊ getItem() }
}

main.split = ➮ {
	context.arr = context.str ⌶ context.otherstr
	context.list = 'arr'
}

main.length = ➮ {
	setNum(context[context.list]↥)
}

main.concat = ➮ {
	setStr(context.str + context.otherstr)
}

main.plus = ➮ {
	setNum(context.num + context.othernum)
}

main.item = ➮ {
	node = node.next
	context.item = node.s
}

main._sentence = ➮ _sentence {
}

main._para = ➮ _para {
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
	str abc-def length print.
	num 555 print.
	str 111 other str 222 concat print.
	num 700 other num 77 plus print.
	item str print.
	item num print.
	str 1,2,3,4,5 other str , split each print.
'''))

/*

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

unknown words:
	word level: token
	sentence level: val
	para level: var
	page level: concept
	vlc dev 2349/774/27792
*/


