This is an early prototype of Lenin.

The name is an acronym that means Lexicaly Enriched Interpreter.

This is a practical attempt to create a semantic oriented programming language.

Currently this repo is "pseudo private", in other words not intendent for public. Later I will write something more meaningful about it. But if you are interested you are welcome to review my work.

Of course, it is written in [elfu][1].
[1]: https://github.com/exebook/elfu
---
An attempt to create a language (at least define example syntax)
that has no parameter passing but instead is fully "context-bound"

- idea is to have more fixed lexems in the programming languages, i.e. thousands
	this will allow a language to be actually "read"
	reading is defined as secuential analyzing of lexems
	but all current programming languages in fact do not allow reading
	defined like this.
	
-	so idea is to emulate how we read and let the computer read the same way
	lexems defined for the project are not lexems but a variables
	variables are evil, lexems are good
	
-	lexem is learned once and forever, unlike "function names" that are project related or even file-related.
	
-	we should have a huge number of commonly recognized lexems
	this will allow better understanding of each other's code
	and allow code to be read fast and natural
	thus "lexically enriched" and "naturally interpreting"
	
- idea is to have at least three context levels

1) word by word context, like left word, right word

2) sentence level, like subject/predicate or simple names inside the sentence.

3) Paragraph context.

4) Page context.

Smaller context cannot update larger context more than one step above.
For example, a word cannot update paragraph context, only a sentence context.
Then the sentence has what in programming languages usually is called a "result" and in lexet it is called "meaning". This "meaning", after the sentence is over, can be passed upwards to a paragraph level.

Similarly paragraph meaning returns back to page level.

Word, sentence, paragraph and page are commonly called syntactic blocks or just blocks. This allows us to talk about them as if they have something in common. And they do. For instance all syntactic blocks can generate code. The code is stored in the current context and then passed to a higher context when the block is ended.

context has fields, which are set by various words (lexems), the word will look for a field with a particular name. But probably we need "classes" as well. For instance if one word creates a context field "pairOfNumbers" and there is a word that works with any pair, it should be able to use the data from pairOfNumbers if it has the "pair" class. How to implement classes remains to be seen. Maybe context:{pairOfNumbers:{a:5, b:7, class:'pair'}}
	or context: {'pairOfNumbers:pair': [5,7]}
	or context: {pair:{instances:[pairOfNumbers:[5,7]]}}
used like this:
	context.getState('pair').a|b
	context.getState('pairOfNumbers')

Idea is to have an unique name for a context that could be used in literature.
For instance 'symtex'. Then define a set of operations on this context object.
This is similar to FORTH stack and a standard set of commands that every programmer knows to operate on this stack. The difference is that Forth command set is small, and we need a lexically enriched language, with a big number of adequately complex 'commands' or they also could be called 'concepts'. Those concepts should be as close to our natural language-bound thinking, but of course formalized. Implementation on this formalization is what makes it difficult to be really close to the natural language, but at least we could close the gap between what programming languages currently are and our natural language.

// Symtex (semantic context) variables, maybe graph,stegra,tixaf
//semantic context graph
//secogra tixaf

X.a = 1
x.b = 2
X[a,b] = print
X = {
	a: { value:1, links:[a_b] },
	b: { value:2, links:[a_b] },
	a_b: { value:print }
}



-----------------------------------------

def plus
	word context: left right // left and right are builtin lexets for nearby words
	{// {} denotes underlying "regular" language
		(return) left + right
	}

usage:

A plus b. // sentence is always capitalized and ends with dot.

-----------------------------------------

def add
	sentence context: nearest list: a b // pair returns/defines a and b
	// nearest means last mentioned 'pair' or if it was not yet mentioned in 
	// current context (here it is sentence context), then the next mention
	// after the defined lexet usage.
	A plus b.

usage:

Add a and b. // 'and' creates a 'pair', which is used(referenced) by 'add'.

--------------
def and
	word context: left right
	{
		context.pair ≜ []
		context.pair ⬊ ([left, right]}
	}

a and b add print.
--------------
def list
	word context: left>left>left until 'and', left
	// i.e.: list a b c and d print.


list 5 50 and 500 add print.
----------------
```
