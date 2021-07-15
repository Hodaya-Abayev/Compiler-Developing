




############ funtions of tokening ###############

function letters(token, currentfile,newFile)
    global keyword
    global symbol
    if !eof(currentfile)
        token=token*string(read(currentfile, Char))
    end
    while all(isletter, token) && !eof(currentfile)
        token=token*string(read(currentfile, Char))
    end
    if token[1:end-1] in keyword
        keywords(token[1:end-1], currentfile,newFile)
        if token[end] in symbol
            symbols(token[end], currentfile,newFile)
        else
            token=""
        end
    else
        idendifier(token, currentfile,newFile)
    end
end


function keywords(token, currentfile, newFile)
    global keyword
    global symbol
    println(newFile, "<keyword> "*token*" </keyword>")
end


function symbols(token, currentfile, newFile)
    global keyword
    global symbol
    if token=='>'
        println(newFile, "<symbol> &gt; </symbol>")
        token=""
    elseif token=='<'
        println(newFile, "<symbol> &lt; </symbol>")
        token=""
    elseif token=='\"'
        println(newFile, "<symbol> &quot; </symbol>")
        token=""
    elseif token=='&'
        println(newFile, "<symbol> &amp; </symbol>")
        token=""
    else
        println(newFile, "<symbol> "*token* " </symbol>")
        token=""
    end
end


function idendifier(token, currentfile, newFile)
    global keyword
    global symbol
    while !(token[end] in symbol) && !(token[end]==' ') && !(token[end]=="\n") && !eof(currentfile)
         token=token*string(read(currentfile, Char))
     end
    println(newFile, "<identifier> "*token[1:end-1]*" </identifier>")
    if token[end] in symbol
        symbols(token[end], currentfile,newFile)
    else
        token=""
    end
end


function StringConstant(token, currentfile, newFile)
    if !eof(currentfile)
        token=""
        token=token*string(read(currentfile, Char))
    end
    while !endswith(token, "\"") && !eof(currentfile)
        token=token*string(read(currentfile, Char))
    end
    println(newFile, "<stringConstant> "*token[1:end-1]* " </stringConstant>")
    token=""
end


function IntegerConstant(token, currentfile, newFile)
    global keyword
    global symbol
    if !eof(currentfile)
        token=token*string(read(currentfile, Char))
    end
    while all(isdigit, token) && !eof(currentfile) #integerConstant
        token=token*string(read(currentfile, Char))
    end
    println(newFile, "<integerConstant> "*token[1:end-1]* " </integerConstant>")
    if token[end] in symbol
        symbols(token[end], currentfile,newFile)
    else
        token=""
    end
end


function comments(token, currentfile)
    global keyword
    global symbol
    if token=='/' && !eof(currentfile)
        line=readline(currentfile)
        token=""
    elseif token=='*' && !eof(currentfile)
        token=string(read(currentfile, Char))
        while !endswith(token, "*/")  && !eof(currentfile)
            token=token*string(read(currentfile, Char))
        end
        token=""
    end
end






############ funtions of parsing ###############

function GetNextToken(tokens)
    global index
    if index+1<=length(tokens)
        index=index+1
        return tokens[index]
    end
end


function CheckNextToken(tokens)
    global index
    if index+1<=length(tokens)
        return tokens[index+1]
    end
end


function ParseClass(tokens, newFile)
    global index
    println(newFile, "<class>")
    println(newFile, GetNextToken(tokens)) #<keyword> class </keyword
    println(newFile, GetNextToken(tokens)) #<idendifier> className </idendifier>
    println(newFile, GetNextToken(tokens)) #<symbol> { </symbol>
    ParseClassVarDec(tokens, newFile)
    ParseClassSubroutineDec(tokens, newFile)
    println(newFile, GetNextToken(tokens)) #<symbol> } </symbol>
    println(newFile, "</class>")
end


function ParseClassVarDec(tokens, newFile)
    while occursin("static",CheckNextToken(tokens)) || occursin("field",CheckNextToken(tokens))
        println(newFile, "<classVarDec>")
        println(newFile, GetNextToken(tokens)) #<keyword> static/field </keyword>
        println(newFile, GetNextToken(tokens)) #<keyword> type </keyword>
        println(newFile, GetNextToken(tokens)) #<idendifier> varName </idendifier>
        while occursin( ",",CheckNextToken(tokens))
            println(newFile, GetNextToken(tokens)) #<symbol> , </symbol>
            println(newFile, GetNextToken(tokens)) #<idendifier> varName </idendifier>
        end
        println(newFile, GetNextToken(tokens)) #<symbol> ; </symbol>
        println(newFile, "</classVarDec>")
    end
end


function ParseClassSubroutineDec(tokens, newFile)
    while occursin( "method",CheckNextToken(tokens)) || occursin("function",CheckNextToken(tokens)) || occursin("constructor",CheckNextToken(tokens))
        println(newFile, "<subroutineDec>")
        println(newFile, GetNextToken(tokens)) #<keyword> method/constructor/function </keyword>
        println(newFile, GetNextToken(tokens)) #<keyword> void </keyword>  /  <idendifier> type </idendifier>
        println(newFile, GetNextToken(tokens)) #<idendifier> subroutineName </idendifier>
        println(newFile, GetNextToken(tokens)) #<symbol> ( </symbol>
        ParseParameterList(tokens, newFile)
        println(newFile, GetNextToken(tokens)) #<symbol> ) </symbol>
        ParseSubroutineBody(tokens, newFile)
        println(newFile, "</subroutineDec>")
    end
end


function ParseParameterList(tokens, newFile)
    println(newFile, "<parameterList>")
    while !occursin( ")",CheckNextToken(tokens))
        println(newFile, GetNextToken(tokens)) #<keyword> type </keyword>
        println(newFile, GetNextToken(tokens)) #<idendifier> varName </idendifier>
        while occursin(",",CheckNextToken(tokens))
            println(newFile, GetNextToken(tokens)) #<symbol> , </symbol>
            println(newFile, GetNextToken(tokens)) #<keyword> type </keyword>
            println(newFile, GetNextToken(tokens)) #<idendifier> varName </idendifier>
        end
    end
    println(newFile, "</parameterList>")
end


function ParseSubroutineBody(tokens, newFile)
    println(newFile, "<subroutineBody>")
    println(newFile, GetNextToken(tokens)) #<symbol> { </symbol>
    ParseVarDec(tokens, newFile)
    ParseStatements(tokens, newFile)
    println(newFile, GetNextToken(tokens)) #<symbol> } </symbol>
    println(newFile, "</subroutineBody>")
end


function ParseVarDec(tokens, newFile)
    while occursin("var",CheckNextToken(tokens))
        println(newFile, "<varDec>")
        println(newFile, GetNextToken(tokens)) #<keyword> var </keyword>
        println(newFile, GetNextToken(tokens)) #<keyword> type </keyword>
        println(newFile, GetNextToken(tokens)) #<idendifier> varName </idendifier>
        while occursin( ",",CheckNextToken(tokens))
            println(newFile, GetNextToken(tokens)) #<symbol> , </symbol>
            println(newFile, GetNextToken(tokens)) #<idendifier> varName </idendifier>
        end
        println(newFile, GetNextToken(tokens)) #<symbol> ; </symbol>
        println(newFile, "</varDec>")
    end
end


function ParseStatements(tokens, newFile)
    println(newFile, "<statements>")
    while occursin( "let",CheckNextToken(tokens)) || occursin( "if",CheckNextToken(tokens)) || occursin( "while",CheckNextToken(tokens)) || occursin( "do",CheckNextToken(tokens)) || occursin( "return",CheckNextToken(tokens))
        if occursin("let",CheckNextToken(tokens))
            ParseLetStatement(tokens, newFile)
        elseif occursin("if",CheckNextToken(tokens))
            ParseIfStatement(tokens, newFile)
        elseif occursin("while",CheckNextToken(tokens))
            ParseWhileStatement(tokens, newFile)
        elseif occursin( "do",CheckNextToken(tokens))
            ParseDoStatement(tokens, newFile)
        elseif occursin( "return",CheckNextToken(tokens))
            ParseReturnStatement(tokens, newFile)
        end
    end
    println(newFile, "</statements>")
end


function ParseLetStatement(tokens, newFile)
    println(newFile, "<letStatement>")
    println(newFile, GetNextToken(tokens)) #<keyword> let </keyword>
    println(newFile, GetNextToken(tokens)) #<idendifier> varName </idendifier>
    if occursin( "[",CheckNextToken(tokens))
        println(newFile, GetNextToken(tokens)) #<symbol> [ </symbol>
            ParseExpression(tokens, newFile)
        println(newFile, GetNextToken(tokens)) #<symbol> ] </symbol>
    end
    println(newFile, GetNextToken(tokens)) #<symbol> = </symbol>
    ParseExpression(tokens, newFile)
    println(newFile, GetNextToken(tokens)) #<symbol> ; </symbol>
    println(newFile, "</letStatement>")
end


function ParseIfStatement(tokens, newFile)
    println(newFile, "<ifStatement>")
    println(newFile, GetNextToken(tokens)) #<keyword> if </keyword>
    println(newFile, GetNextToken(tokens)) #<symbol> ( </symbol>
    ParseExpression(tokens, newFile)
    println(newFile, GetNextToken(tokens)) #<symbol> ) </symbol>
    println(newFile, GetNextToken(tokens)) #<symbol> { </symbol>
    ParseStatements(tokens, newFile)
    println(newFile, GetNextToken(tokens)) #<symbol> } </symbol>
    if occursin( "else",CheckNextToken(tokens))
        println(newFile, GetNextToken(tokens)) #<keyword> let </keyword>
        println(CheckNextToken(tokens))################################################################################################
        println(newFile, GetNextToken(tokens)) #<symbol> { </symbol>
        ParseStatements(tokens, newFile)
        println(newFile, GetNextToken(tokens)) #<symbol> } </symbol>
    end
    println(newFile, "</ifStatement>")
end


function ParseWhileStatement(tokens, newFile)
    println(newFile, "<whileStatement>")
    println(newFile, GetNextToken(tokens)) #<keyword> while </keyword>
    println(newFile, GetNextToken(tokens)) #<symbol> ( </symbol>
    ParseExpression(tokens, newFile)
    println(newFile, GetNextToken(tokens)) #<symbol> ) </symbol>
    println(newFile, GetNextToken(tokens)) #<symbol> { </symbol>
    ParseStatements(tokens, newFile)
    println(newFile, GetNextToken(tokens)) #<symbol> } </symbol>
    println(newFile, "</whileStatement>")
end


function ParseDoStatement(tokens, newFile)
    println(newFile, "<doStatement>")
    println(newFile, GetNextToken(tokens)) #<keyword> do </keyword>
    println(newFile, GetNextToken(tokens)) #<idendifier> className/subRoutineName </idendifier>
    subroutineCall(tokens, newFile)
    println(newFile, GetNextToken(tokens)) #<symbol> ; </symbol>
    println(newFile, "</doStatement>")
end


function ParseReturnStatement(tokens, newFile)
    println(newFile, "<returnStatement>")
    println(newFile, GetNextToken(tokens)) #<keyword> return </keyword>
    if !occursin( ";",CheckNextToken(tokens))
        ParseExpression(tokens, newFile)
    end
    println(newFile, GetNextToken(tokens)) #<symbol> ; </symbol>
    println(newFile, "</returnStatement>")
end


function ParseExpression(tokens, newFile)
    println(newFile, "<expression>")
    ParseTerm(tokens, newFile)
    while occursin( " + ",CheckNextToken(tokens)) || occursin( " - ",CheckNextToken(tokens)) || occursin( " * ",CheckNextToken(tokens)) || occursin( " / ",CheckNextToken(tokens)) || occursin( "&amp;",CheckNextToken(tokens)) ||
        occursin( " | ",CheckNextToken(tokens))|| occursin( "&lt;",CheckNextToken(tokens)) || occursin( "&gt;",CheckNextToken(tokens)) || occursin( " = ",CheckNextToken(tokens))
        println(newFile, GetNextToken(tokens)) #<symbol> op </symbol>
        ParseTerm(tokens, newFile)
    end
    println(newFile, "</expression>")
end


function ParseTerm(tokens, newFile)
    println(newFile, "<term>")
    if  occursin( "stringConstant",CheckNextToken(tokens)) || occursin( "integerConstant",CheckNextToken(tokens))
        println(newFile, GetNextToken(tokens)) #/<integerConstant> integerConstant </integerConstant> /<stringConstant> stringConstant </stringConstant>
    elseif occursin( "true",CheckNextToken(tokens)) || occursin( "false",CheckNextToken(tokens)) || occursin( "null",CheckNextToken(tokens))|| occursin( "this",CheckNextToken(tokens))
        println(newFile, GetNextToken(tokens))#<keyword> keywordConstant </keyword>
    elseif occursin( "identifier",CheckNextToken(tokens))
        println(newFile, GetNextToken(tokens)) #<idendifier> varName/className/subRoutineName </idendifier>
        if occursin( "[",CheckNextToken(tokens))
            println(newFile, GetNextToken(tokens)) #<symbol> [ </symbol>
            ParseExpression(tokens,newFile)
            println(newFile, GetNextToken(tokens)) #<symbol> ] </symbol>
        elseif occursin( "(",CheckNextToken(tokens)) || occursin( ".",CheckNextToken(tokens))
            subroutineCall(tokens, newFile)
        end
    elseif  occursin( "(",CheckNextToken(tokens))
        println(newFile, GetNextToken(tokens)) #<symbol> ( </symbol>
        ParseExpression(tokens,newFile)
        println(newFile, GetNextToken(tokens)) #<symbol> ) </symbol>
    elseif  occursin( "-",CheckNextToken(tokens)) ||  occursin( "~",CheckNextToken(tokens))
        println(newFile, GetNextToken(tokens)) #<symbol> -/~ </symbol>
        ParseTerm(tokens, newFile)
    end
    println(newFile, "</term>")
end


function subroutineCall(tokens, newFile)
    if occursin( "(",CheckNextToken(tokens))
        println(newFile, GetNextToken(tokens)) #<symbol> ( </symbol>
        ParseExpressionList(tokens,newFile)
        println(newFile, GetNextToken(tokens)) #<symbol> ) </symbol>
    else
        println(newFile, GetNextToken(tokens)) #<symbol> . </symbol>
        println(newFile, GetNextToken(tokens)) #<idendifier> subRoutineName </idendifier>
        println(newFile, GetNextToken(tokens)) #<symbol> ( </symbol>
        ParseExpressionList(tokens,newFile)
        println(newFile, GetNextToken(tokens)) #<symbol> ) </symbol>
    end
end


function ParseExpressionList(tokens,newFile)
    println(newFile, "<expressionList>")
    while !occursin( ")",CheckNextToken(tokens))
        ParseExpression(tokens,newFile)
        while occursin( ",",CheckNextToken(tokens))
            println(newFile,  GetNextToken(tokens)) #<symbol>, </symbol>
            ParseExpression(tokens,newFile)
        end
    end
    println(newFile, "</expressionList>")
end





############ main ##############

global keyword=["class","constructor","function","method","field","static","let","do","if","else","while","return","var","int","char","boolean","void","true","false","null","this"]
global symbol=['{','}','(',')','[',']','.',',',';','+','-','*','/','&','|','<','>','=','~']
global index=1
path=input()
arr=split(path, "\\")
files=readdir(path)
for file in files
    if endswith(file, ".jack")
        currentfile=open(path*'\\'*file, "r")
        file=SubString(file, 1, length(file)-5)
        newFile=open(path*"\\"*file*"T.xml", "w")
        println(newFile, "<tokens>")
        token=""
        while !eof(currentfile)
            token=token*string(read(currentfile, Char))
            if token=="/"  && !eof(currentfile)
                token2=read(currentfile, Char)
                if token2=='/' || token2=='*'
                    comments(token2, currentfile)
                else
                    symbols(token[end], currentfile, newFile)
                    if isdigit(token2)
                        IntegerConstant(token2, currentfile, newFile)
                    elseif token2==' '
                        token=""
                    else
                        idendifier(token2, currentfile, newFile)
                    end
                end
            elseif all(isletter, token)
                letters(token, currentfile,newFile)

            elseif all(isdigit, token)
                IntegerConstant(token, currentfile,newFile)

            elseif token[end] in symbol #symbol
                symbols(token[end], currentfile,newFile)

            elseif token[end]=='\"' && !eof(currentfile)#stringConstant
                StringConstant(token, currentfile,newFile)

            elseif token[end]=='_' && !eof(currentfile)
                token=token*string(read(currentfile, Char))
                idendifier(token, currentfile,newFile)

            elseif (token[end]=="\n"||token[end]=='\t'|| token[end]==' ') &&!eof(currentfile)
                token=""
            end
            token=""
        end
        println(newFile, "</tokens>")
        close(currentfile)  #main.jack
        close(newFile)      #mainT.xml
        currentfile=open(path*"\\"*file*"T.xml", "r") #mainT.xml
        newFile=open(path*"\\"*file*".xml", "w")
        tokens=readlines(currentfile)
        ParseClass(tokens, newFile)
        close(currentfile)
        close(newFile)
        global index=1
    end
end
