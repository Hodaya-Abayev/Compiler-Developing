


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
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    token=GetNextToken(tokens) #<keyword> class </keyword
    token=GetNextToken(tokens) #<idendifier> className </idendifier>
    global className=split(token, " ")[2]
    token=GetNextToken(tokens) #<symbol> { </symbol>
    ParseClassVarDec(tokens, newFile)
    ParseClassSubroutineDec(tokens, newFile)
    token=GetNextToken(tokens) #<symbol> } </symbol>
    StaticCounter=0
    whileCounter=0
end



function ParseClassVarDec(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    while occursin("classVarDec", CheckNextToken(tokens))
        token=GetNextToken(tokens) #"<classVarDec>"
        kind=GetNextToken(tokens) #<keyword> static/field </keyword>
        type=GetNextToken(tokens) #<keyword> type </keyword>
        varName=GetNextToken(tokens) #<idendifier> varName </idendifier>
        if occursin("static", kind)
            row=[split(varName, " ")[2] split(type, " ")[2] split(kind, " ")[2] StaticCounter]
            StaticCounter=StaticCounter+1
        else
            row=[split(varName, " ")[2] split(type, " ")[2] split(kind, " ")[2] FieldsCounter]
            FieldsCounter=FieldsCounter+1
        end
        classMatrix=[classMatrix; row]
        while occursin( ",",CheckNextToken(tokens))
            token=GetNextToken(tokens) #<symbol> , </symbol>
            varName=GetNextToken(tokens) #<idendifier> varName </idendifier>
            if occursin("static", kind)
                row=[split(varName, " ")[2] split(type, " ")[2] split(kind, " ")[2] StaticCounter]
                StaticCounter=StaticCounter+1
            else
                row=[split(varName, " ")[2] split(type, " ")[2] split(kind, " ")[2] FieldsCounter]
                FieldsCounter=FieldsCounter+1
            end
            classMatrix=[classMatrix; row]
        end
        token=GetNextToken(tokens) #<symbol> ; </symbol>
        token=GetNextToken(tokens) #"</classVarDec>"
    end
end


function ParseClassSubroutineDec(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    while occursin("subroutineDec", CheckNextToken(tokens))
        functionMatrix=zeros(0,4)
        token=GetNextToken(tokens) #"<subroutineDec>"
        functionType=GetNextToken(tokens) #<keyword> method/constructor/function </keyword>
        if occursin("method", functionType)
            row=["this" className "argument" ArgumentsCounter]
            ArgumentsCounter=ArgumentsCounter+1
            functionMatrix=[functionMatrix; row]
        end
        token=GetNextToken(tokens) #<keyword> void </keyword>  /  <idendifier> type </idendifier>
        functionName=split(GetNextToken(tokens), " ")[2] #<idendifier> subroutineName </idendifier>
        token=GetNextToken(tokens) #<symbol> ( </symbol>
        ParseParameterList(tokens, newFile)
        token=GetNextToken(tokens) #<symbol> ) </symbol>
        ParseSubroutineBody(tokens, newFile, split(functionType, " ")[2])
        token=GetNextToken(tokens) #"</subroutineDec>"
        functionMatrix=zeros(0,4)
        ArgumentsCounter=0
        VarsCounter=0
    end
end


function ParseParameterList(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    token=GetNextToken(tokens) #<parameterList>
    while !occursin( "parameterList",CheckNextToken(tokens))
        type=GetNextToken(tokens) #<keyword> type </keyword>
        varName=GetNextToken(tokens) #<idendifier> varName </idendifier>
        row=[split(varName, " ")[2] split(type, " ")[2] "argument" ArgumentsCounter]
        ArgumentsCounter=ArgumentsCounter+1
        functionMatrix=[functionMatrix; row]
        while occursin(",",CheckNextToken(tokens))
            token=GetNextToken(tokens) #<symbol> , </symbol>
            type=GetNextToken(tokens) #<keyword> type </keyword>
            varName=GetNextToken(tokens) #<idendifier> varName </idendifier>
            row=[split(varName, " ")[2] split(type, " ")[2] "argument" ArgumentsCounter]
            ArgumentsCounter=ArgumentsCounter+1
            functionMatrix=[functionMatrix; row]
        end
    end
    token=GetNextToken(tokens) #</parameterList>
end


function ParseSubroutineBody(tokens, newFile, functionType)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    token=GetNextToken(tokens) #<subroutineBody>
    token=GetNextToken(tokens) #<symbol> { </symbol>
    ParseVarDec(tokens, newFile)
    println(newFile, "function "*className*"."*functionName*" "*string(VarsCounter)) #function decleration
    if functionType=="method"#check function type
        println(newFile, "push argument 0")
        println(newFile, "pop pointer 0")
    elseif functionType=="constructor"
        println(newFile, "push constant "*string(FieldsCounter))
        println(newFile, "call Memory.alloc 1")
        println(newFile, "pop pointer 0")
    end
    ParseStatements(tokens, newFile)
    token=GetNextToken(tokens) #<symbol> } </symbol>
    token=GetNextToken(tokens) #<symbol> </subroutineBody> </symbol>
end


function ParseVarDec(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    while occursin("<varDec>",CheckNextToken(tokens))
        token=GetNextToken(tokens) #<varDec>
        kind=GetNextToken(tokens) #<keyword> var </keyword>
        type=GetNextToken(tokens) #<keyword> type </keyword>
        varName=GetNextToken(tokens) #<idendifier> varName </idendifier>
        row=[split(varName, " ")[2] split(type, " ")[2] "var" VarsCounter]
        VarsCounter=VarsCounter+1
        functionMatrix=[functionMatrix; row]
        while occursin( ",",CheckNextToken(tokens))
            token=GetNextToken(tokens) #<symbol> , </symbol>
            varName=GetNextToken(tokens) #<idendifier> varName </idendifier>
            row=[split(varName, " ")[2] split(type, " ")[2] "var" VarsCounter]
            functionMatrix=[functionMatrix; row]
            VarsCounter=VarsCounter+1
        end
        token=GetNextToken(tokens) #<symbol> ; </symbol>
        token=GetNextToken(tokens) #</varDec>

    end
end


function ParseStatements(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    token=GetNextToken(tokens) #<statements>
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
    token=GetNextToken(tokens) #</statements>
end


function ParseLetStatement(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    mysymbol=[]
    token=GetNextToken(tokens) #<letStatement>
    token=GetNextToken(tokens) #<keyword> let </keyword>
    varName=split(GetNextToken(tokens), " ")[2] #<idendifier> varName </idendifier>
    for j =1:size(functionMatrix,1)
        row=[functionMatrix[j,1] functionMatrix[j,2] functionMatrix[j,3] functionMatrix[j,4]]
        if row[1]==varName
            mysymbol=row
        end
    end
    if mysymbol==[]
        for j =1:size(classMatrix,1)
            row=[classMatrix[j,1] classMatrix[j,2] classMatrix[j,3] classMatrix[j,4]]
            if row[1]==varName
                mysymbol=row
            end
        end
    end
    if occursin( "[",CheckNextToken(tokens))
        token=GetNextToken(tokens) #<symbol> [ </symbol>
        ParseExpression(tokens, newFile)
        if mysymbol[3]=="field" || mysymbol[3]=="static"#find the location in the array
            println(newFile, "push this "*string(mysymbol[4]))
        elseif mysymbol[3]=="var"
            println(newFile, "push local "*string(mysymbol[4]))
        elseif mysymbol[3]=="argument"
            println(newFile, "push argument "*string(mysymbol[4]))
        end
        println(newFile,"add")
        token=GetNextToken(tokens) #<symbol> ] </symbol>
        token= GetNextToken(tokens) #<symbol> = </symbol>
        ParseExpression(tokens, newFile)
        println(newFile,"pop temp 0") #the value to assign
        println(newFile,"pop pointer 1") #the location in the array
        println(newFile,"push temp 0") #the value to assign
        println(newFile,"pop that 0") #the value inserted to the array
    else
        token= GetNextToken(tokens) #<symbol> = </symbol>
        ParseExpression(tokens, newFile)
        if mysymbol[3]=="field"
            println(newFile, "pop this "*string(mysymbol[4]))
        elseif mysymbol[3]=="static"
            println(newFile, "pop static "*string(mysymbol[4]))
        elseif mysymbol[3]=="var"
            println(newFile, "pop local "*string(mysymbol[4]))
        elseif mysymbol[3]=="argument"
            println(newFile, "pop argument "*string(mysymbol[4]))
        end
    end
    token=GetNextToken(tokens) #<symbol> ; </symbol>
    token=GetNextToken(tokens) #</letStatement>
end


function ParseIfStatement(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileCounter
    global ifCounter
    token=GetNextToken(tokens) #<ifStatement>
    token=GetNextToken(tokens) #<keyword> if </keyword>
    token=GetNextToken(tokens) #<symbol> ( </symbol>
    ParseExpression(tokens, newFile)
    token=GetNextToken(tokens) #<symbol> ) </symbol>
    tempCounter=ifCounter
    println(newFile, "if-goto "*"IF_TRUE"*string(tempCounter))
    println(newFile, "goto "*"IF_FALSE"*string(tempCounter))
    token=GetNextToken(tokens) #<symbol> { </symbol>
    println(newFile,"label "*"IF_TRUE"*string(tempCounter))
    ifCounter=ifCounter+1
    ParseStatements(tokens, newFile)
    token=GetNextToken(tokens) #<symbol> } </symbol>
    if occursin( "else",CheckNextToken(tokens))
        println(newFile,"goto IF_END"*string(tempCounter))
        println(newFile,"label "*"IF_FALSE"*string(tempCounter))
        token=GetNextToken(tokens) #<keyword> else </keyword>
        token=GetNextToken(tokens) #<symbol> { </symbol>
        ParseStatements(tokens, newFile)
        token=GetNextToken(tokens) #<symbol> } </symbol>
        println(newFile,"label IF_END"*string(tempCounter))
    else
        println(newFile,"label "*"IF_FALSE"*string(tempCounter))
    end
    token=GetNextToken(tokens) #</ifStatement>
end


function ParseWhileStatement(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifCounter
    global whileExpCounter
    global whileCounter
    token=GetNextToken(tokens) #<whileStatement>
    token=GetNextToken(tokens) #<keyword> while </keyword>
    tempCounter=whileCounter
    println(newFile, "label WHILE_EXP"*string(tempCounter))
    whileCounter=whileCounter+1
    token=GetNextToken(tokens) #<symbol> ( </symbol>
    ParseExpression(tokens, newFile)
    println(newFile, "not")
    token=GetNextToken(tokens) #<symbol> ) </symbol>
    println(newFile, "if-goto WHILE_END"*string(tempCounter))
    token=GetNextToken(tokens) #<symbol> { </symbol>
    ParseStatements(tokens, newFile)
    token=GetNextToken(tokens) #<symbol> } </symbol>
    println(newFile, "goto WHILE_EXP"*string(tempCounter))
    println(newFile, "label WHILE_END"*string(tempCounter))
    token=GetNextToken(tokens) #</whileStatement>
end


function ParseDoStatement(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    token= GetNextToken(tokens)#<doStatement>
    token= GetNextToken(tokens)#<keyword> do </keyword>
    subroutineCall(tokens, newFile)
    ParametersCounter=0
    println(newFile, "pop temp 0")
    token=GetNextToken(tokens) #<symbol> ; </symbol>
    token=GetNextToken(tokens)#"</doStatement>"
end


function ParseReturnStatement(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    token= GetNextToken(tokens)#"<returnStatement>"
    token= GetNextToken(tokens)#<keyword> return </keyword>
    if !occursin( ";",CheckNextToken(tokens))
        ParseExpression(tokens, newFile)
    else
        println(newFile, "push constant 0")
    end
    token=GetNextToken(tokens) #<symbol> ; </symbol>
    token=GetNextToken(tokens)#"</returnStatement>"
    println(newFile, "return")
end


function ParseExpression(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    token=GetNextToken(tokens) #<expression>
    ParseTerm(tokens, newFile)
    while occursin( " + ",CheckNextToken(tokens)) || occursin( " - ",CheckNextToken(tokens)) || occursin( " * ",CheckNextToken(tokens)) || occursin( " / ",CheckNextToken(tokens)) || occursin( "&amp;",CheckNextToken(tokens)) ||
        occursin( " | ",CheckNextToken(tokens))|| occursin( "&lt;",CheckNextToken(tokens)) || occursin( "&gt;",CheckNextToken(tokens)) || occursin( " = ",CheckNextToken(tokens))
        token=GetNextToken(tokens) #<symbol> op </symbol>
        ParseTerm(tokens, newFile)
        if occursin( " + ",token)
            println(newFile,"add")
        elseif occursin( " - ",token)
            println(newFile,"sub")
        elseif occursin( " * ",token)
            println(newFile,"call Math.multiply 2")
        elseif occursin( " | ",token)
            println(newFile,"or")
        elseif occursin( " &lt; ",token)
            println(newFile,"lt")
        elseif occursin( " &gt; ",token)
            println(newFile,"gt")
        elseif occursin( " / ",token)
            println(newFile,"call Math.divide 2")
        elseif occursin( " &amp; ",token)
            println(newFile,"and")
        elseif occursin( " = ",token)
            println(newFile,"eq")
        end
    end
    token=GetNextToken(tokens)  #<expression>
end


function ParseTerm(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    mysymbol=[]
    token=GetNextToken(tokens) #<term>
    if  occursin( "stringConstant",CheckNextToken(tokens))
        stringConstant=split(GetNextToken(tokens), " ")#/<integerConstant> integerConstant </integerConstant>
        fullString=stringConstant[2]
        for i in 3:length(stringConstant)-1
            fullString=fullString*" "*stringConstant[i]
        end
        println(newFile, "push constant "*string(length(fullString)))
        println(newFile,"call String.new 1")
        for letter in fullString
            println(newFile, "push constant "*string(Int64(letter)))
            println(newFile, "call String.appendChar 2")
        end
    elseif occursin( "integerConstant",CheckNextToken(tokens))
        integerConstant=split(GetNextToken(tokens), " ")[2] #/<integerConstant> integerConstant </integerConstant>
        println(newFile, "push constant "*integerConstant)
    elseif occursin( "true",CheckNextToken(tokens))
        token=GetNextToken(tokens) #<keyword> keywordConstant </keyword>
        println(newFile, "push constant 0")
        println(newFile, "not")
    elseif occursin( "false",CheckNextToken(tokens)) || occursin("null",CheckNextToken(tokens))
        token=GetNextToken(tokens) #<keyword> keywordConstant </keyword>
        println(newFile, "push constant 0")
    elseif occursin( "this",CheckNextToken(tokens))
        token=GetNextToken(tokens) #<keyword> keywordConstant </keyword>
        println(newFile, "push pointer 0")
    elseif occursin( "identifier",CheckNextToken(tokens))
        varName=split(GetNextToken(tokens), " ")[2] #<idendifier> varName/className/subRoutineName </idendifier>
        for j =1:size(functionMatrix,1)
            row=[functionMatrix[j,1] functionMatrix[j,2] functionMatrix[j,3] functionMatrix[j,4]]
            if row[1]==varName
                mysymbol=row
            end
        end
        if mysymbol==[]
            for j =1:size(classMatrix,1)
                row=[classMatrix[j,1] classMatrix[j,2] classMatrix[j,3] classMatrix[j,4]]
                if row[1]==varName
                    mysymbol=row
                end
            end
        end
        if occursin( "[",CheckNextToken(tokens))
            token=GetNextToken(tokens) #<symbol> [ </symbol>
            ParseExpression(tokens, newFile)
            token=GetNextToken(tokens) #<symbol> ] </symbol>
            if mysymbol!=[]
                if mysymbol[3]=="field" || mysymbol[3]=="static"#find the location in the array
                    println(newFile, "push this "*string(mysymbol[4]))
                elseif mysymbol[3]=="var"
                    println(newFile, "push local "*string(mysymbol[4]))
                elseif mysymbol[3]=="argument"
                    println(newFile, "push argument "*string(mysymbol[4]))
                end
            end
            println(newFile,"add")
            println(newFile,"pop pointer 1") #the location in the array
            println(newFile,"push that 0") #the value inserted to the array
        elseif occursin( "(",CheckNextToken(tokens)) || occursin( ".",CheckNextToken(tokens))# identifier is subRoutineName
            index=index-1
            subroutineCall(tokens, newFile)
            ParametersCounter=0
        else
            if mysymbol!=[]
                if mysymbol[3]=="field"
                    println(newFile, "push this "*string(mysymbol[4]))
                elseif mysymbol[3]=="static"
                    println(newFile, "push static "*string(mysymbol[4]))
                elseif mysymbol[3]=="var"
                    println(newFile, "push local "*string(mysymbol[4]))
                elseif mysymbol[3]=="argument"
                    println(newFile, "push argument "*string(mysymbol[4]))
                end
            end
        end
    elseif occursin( "(",CheckNextToken(tokens))
        token=GetNextToken(tokens) #<symbol> ( </symbol>
        ParseExpression(tokens,newFile)
        GetNextToken(tokens) #<symbol> ) </symbol>
    elseif  occursin( "-",CheckNextToken(tokens))
        token=GetNextToken(tokens) #<symbol> - </symbol>
        ParseTerm(tokens, newFile)
        println(newFile, "neg")
    elseif  occursin( "~",CheckNextToken(tokens))
        token=GetNextToken(tokens) #<symbol> ~ </symbol>
        ParseTerm(tokens, newFile)
        println(newFile, "not")

    end
    token=GetNextToken(tokens)  #</term>
end


function subroutineCall(tokens, newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    mysymbol=[]
    identifier=split(GetNextToken(tokens), " ")[2] #<idendifier> className/subRoutineName </idendifier>
    if occursin( "(",CheckNextToken(tokens))
        token=GetNextToken(tokens) #<symbol> ( </symbol>
        ParametersCounter=ParametersCounter+1
        println(newFile, "push pointer 0")
        ParseExpressionList(tokens,newFile)
        println(newFile, "call "*className*"."*identifier*" "*string(ParametersCounter))
        token=GetNextToken(tokens) #<symbol> ) </symbol>
    else
        token=GetNextToken(tokens) #<symbol> . </symbol>
        subRoutineName=split(GetNextToken(tokens), " ")[2] #<idendifier> subRoutineName </idendifier>
        for j =1:size(functionMatrix,1)
            row=[functionMatrix[j,1] functionMatrix[j,2] functionMatrix[j,3] functionMatrix[j,4]]
            if row[1]==identifier
                mysymbol=row
            end
        end
        if mysymbol==[]
            for j =1:size(classMatrix,1)
                row=[classMatrix[j,1] classMatrix[j,2] classMatrix[j,3] classMatrix[j,4]]
                if row[1]==identifier
                    mysymbol=row
                end
            end
        end
        if mysymbol!=[]#the identifier is varName
            if mysymbol[3]=="field" || mysymbol[3]=="static"
                println(newFile, "push this "*string(mysymbol[4]))
            elseif mysymbol[3]=="argument"
                println(newFile, "push argument "*string(mysymbol[4]))
            elseif mysymbol[3]=="var"
                println(newFile, "push local "*string(mysymbol[4]))
            end
            token=GetNextToken(tokens) #<symbol> ( </symbol>
            ParseExpressionList(tokens,newFile)
            ParametersCounter=ParametersCounter+1
            println(newFile, "call "*mysymbol[2]*"."*subRoutineName*" "*string(ParametersCounter))
        else #identifier is other class
            token=GetNextToken(tokens) #<symbol ( </symbol>
            ParseExpressionList(tokens,newFile)
            println(newFile, "call "*identifier*"."*subRoutineName*" "*string(ParametersCounter))
        end
        token=GetNextToken(tokens) #<symbol> ) </symbol>
    end
end


function ParseExpressionList(tokens,newFile)
    global classMatrix
    global functionMatrix
    global index
    global className
    global functionName
    global StaticCounter
    global FieldsCounter
    global ArgumentsCounter
    global VarsCounter
    global ParametersCounter
    global ifTrueCounter
    global ifFalseCounter
    global whileExpCounter
    global whileEndCounter
    token=GetNextToken(tokens) #<expressionList>
    while !occursin( "expressionList",CheckNextToken(tokens))
        ParametersCounter=ParametersCounter+1
        ParseExpression(tokens,newFile)
        while occursin( ",",CheckNextToken(tokens))
            token=GetNextToken(tokens) #<symbol>, </symbol>
            ParametersCounter=ParametersCounter+1
            ParseExpression(tokens,newFile)
        end
    end
    token=GetNextToken(tokens) #</expressionList>
end





global classMatrix=zeros(0,4)
global functionMatrix=zeros(0,4)
global index=1
global className=""
global functionName=""
global StaticCounter=0
global FieldsCounter=0
global ArgumentsCounter=0
global VarsCounter=0
global ParametersCounter=0
global ifTrueCounter=0
global ifFalseCounter=0
global ifCounter=0
global whileCounter=0
global whileEndCounter=0
path=input()
arr=split(path, "\\")
files=readdir(path)
for file in files
    if endswith(file, ".xml") && !endswith(file, "T.xml")
        currentfile=open(path*'\\'*file, "r")
        file=SubString(file, 1, length(file)-3)
        newFile=open(path*"\\"*file*"vm", "w")
        tokens=readlines(currentfile)
        ParseClass(tokens, newFile)
        close(currentfile)
        close(newFile)
        global index=1
        global classMatrix=zeros(0,4)
        StaticCounter=0
        FieldsCounter=0
    end
end
