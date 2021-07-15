

function HandlePushCommand(segment, index, file)
    indexInt=parse(Int64, index)
    println(newFile, "//push "*segment*" "*index)
    if(segment=="argument")
        println(newFile, "@"*index)
        println(newFile, "D=A")
        println(newFile, "@"*"ARG")
        println(newFile, "A=M+D")
        println(newFile, "D=M")
        println(newFile, "@SP")
        println(newFile, "A=M")
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M+1")
    elseif(segment=="local")
        println(newFile, "@"*index)
        println(newFile, "D=A")
        println(newFile, "@"*"LCL")
        println(newFile, "A=M+D")
        println(newFile, "D=M")
        println(newFile, "@SP")
        println(newFile, "A=M")
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M+1")
    elseif(segment=="static")
        file=SubString(file, 1, length(file)-2)
        println(newFile, "@"*file*index)
        println(newFile, "D=M")
        println(newFile, "@SP")
        println(newFile, "A=M")
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M+1")
    elseif(segment=="constant")
        println(newFile, "@"*index)
        println(newFile, "D=A")
        println(newFile, "@SP")
        println(newFile, "A=M")
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M+1")
    elseif(segment=="this")
        println(newFile, "@"*index)
        println(newFile, "D=A")
        println(newFile, "@"*"THIS")
        println(newFile, "A=M+D")
        println(newFile, "D=M")
        println(newFile, "@SP")
        println(newFile, "A=M")
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M+1")
    elseif(segment=="that")
        println(newFile, "@"*index)
        println(newFile, "D=A")
        println(newFile, "@"*"THAT")
        println(newFile, "A=M+D")
        println(newFile, "D=M")
        println(newFile, "@SP")
        println(newFile, "A=M")
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M+1")
    elseif(segment=="pointer")
        if(indexInt==0)
            println(newFile, "@"*"THIS")
        elseif(indexInt==1)
            println(newFile, "@"*"THAT")
        end
        println(newFile, "D=M")
        println(newFile, "@SP")
        println(newFile, "A=M")
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M+1")
    elseif(segment=="temp")
        println(newFile, "@"*string(indexInt+5))
        println(newFile, "D=M")
        println(newFile, "@SP")
        println(newFile, "A=M")
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M+1")
    end

end


function HandlePopCommand(segment, index, file)
    indexInt=parse(Int64, index)
    println(newFile, "//pop "*segment*" "*index)
    if(segment=="argument")
        println(newFile, "@SP")
        println(newFile, "A=M-1")
        println(newFile, "D=M")
        println(newFile, "@"*"ARG")
        println(newFile, "A=M")
        for i in 1:indexInt
            println(newFile, "A=A+1")
        end
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M-1")
    elseif(segment=="local")
        println(newFile, "@SP")
        println(newFile, "A=M-1")
        println(newFile, "D=M")
        println(newFile, "@"*"LCL")
        println(newFile, "A=M")
        for i in 1:indexInt
            println(newFile, "A=A+1")
        end
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M-1")
    elseif(segment=="static")
        file=SubString(file, 1, length(file)-2)
        println(newFile, "@SP")
        println(newFile, "M=M-1")
        println(newFile, "A=M")
        println(newFile, "D=M")
        println(newFile, "@"*file*index)
        println(newFile, "M=D")
    elseif(segment=="this")
        println(newFile, "@SP")
        println(newFile, "A=M-1")
        println(newFile, "D=M")
        println(newFile, "@"*"THIS")
        println(newFile, "A=M")
        for i in 1:indexInt
            println(newFile, "A=A+1")
        end
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M-1")
    elseif(segment=="that")
        println(newFile, "@SP")
        println(newFile, "A=M-1")
        println(newFile, "D=M")
        println(newFile, "@"*"THAT")
        println(newFile, "A=M")
        for i in 1:indexInt
            println(newFile, "A=A+1")
        end
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M-1")
    elseif(segment=="pointer")
        println(newFile, "@SP")
        println(newFile, "A=M-1")
        println(newFile, "D=M")
        if(indexInt==0)
            println(newFile, "@"*"THIS")
        elseif(indexInt==1)
            println(newFile, "@"*"THAT")
        end
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M-1")
    elseif(segment=="temp")
        println(newFile, "@SP")
        println(newFile, "A=M-1")
        println(newFile, "D=M")
        println(newFile, "@"*string(indexInt+5))
        println(newFile, "M=D")
        println(newFile, "@SP")
        println(newFile, "M=M-1")
    end
end




function HandleAddCommand()
    println(newFile, "//add")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "D=M")
    println(newFile, "A=A-1")
    println(newFile, "M=M+D")
    println(newFile, "@SP")
    println(newFile, "M=M-1")
end


function HandleSubCommand()
    println(newFile, "//sub")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "D=M")
    println(newFile, "A=A-1")
    println(newFile, "M=M-D")
    println(newFile, "@SP")
    println(newFile, "M=M-1")
end


function HandleNegCommand()
    println(newFile, "//neg")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "M=-M")
end


function HandleEqCommand()
    global counterTrue
    global counterFalse
    counterTrueString=string(counterTrue)
    counterFalseString=string(counterFalse)
    println(newFile, "//eq")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "D=M")
    println(newFile, "A=A-1")
    println(newFile, "D=M-D")
    println(newFile, "@IF_TRUE"*counterTrueString)
    println(newFile, "D;JEQ")
    println(newFile, "D=0")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "A=A-1")
    println(newFile, "M=D")
    println(newFile, "@IF_FALSE"*counterFalseString)
    println(newFile, "0;JMP")
    println(newFile, "(IF_TRUE"*counterTrueString*")")
    counterTrue+=1
    println(newFile, "D=-1")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "A=A-1")
    println(newFile, "M=D")
    println(newFile, "(IF_FALSE"*counterFalseString*")")
    counterFalse+=1
    println(newFile, "@SP")
    println(newFile, "M=M-1")
end


function HandleGtCommand()
    global counterTrue
    global counterFalse
    counterTrueString=string(counterTrue)
    counterFalseString=string(counterFalse)
    println(newFile, "//gt")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "D=M")
    println(newFile, "A=A-1")
    println(newFile, "D=M-D")
    println(newFile, "@IF_TRUE"*counterTrueString)
    println(newFile, "D;JGT")
    println(newFile, "D=0")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "A=A-1")
    println(newFile, "M=D")
    println(newFile, "@IF_FALSE"*counterFalseString)
    println(newFile, "0;JMP")
    println(newFile, "(IF_TRUE"*counterTrueString*")")
    counterTrue+=1
    println(newFile, "D=-1")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "A=A-1")
    println(newFile, "M=D")
    println(newFile, "(IF_FALSE"*counterFalseString*")")
    counterFalse+=1
    println(newFile, "@SP")
    println(newFile, "M=M-1")
end


function HandleLtCommand()
    global counterTrue
    global counterFalse
    counterTrueString=string(counterTrue)
    counterFalseString=string(counterFalse)
    println(newFile, "//lt")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "D=M")
    println(newFile, "A=A-1")
    println(newFile, "D=M-D")
    println(newFile, "@IF_TRUE"*counterTrueString)
    println(newFile, "D;JLT")
    println(newFile, "D=0")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "A=A-1")
    println(newFile, "M=D")
    println(newFile, "@IF_FALSE"*counterFalseString)
    println(newFile, "0;JMP")
    println(newFile, "(IF_TRUE"*counterTrueString*")")
    counterTrue+=1
    println(newFile, "D=-1")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "A=A-1")
    println(newFile, "M=D")
    println(newFile, "(IF_FALSE"*counterFalseString*")")
    counterFalse+=1
    println(newFile, "@SP")
    println(newFile, "M=M-1")
end


function HandleAndCommand()
    println(newFile, "//and")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "D=M")
    println(newFile, "A=A-1")
    println(newFile, "M=D&M")
    println(newFile, "@SP")
    println(newFile, "M=M-1")
end


function HandleOrCommand()
    println(newFile, "//or")
    println(newFile, "//and")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "D=M")
    println(newFile, "A=A-1")
    println(newFile, "M=D|M")
    println(newFile, "@SP")
    println(newFile, "M=M-1")

end


function HandleNotCommand()
    println(newFile, "//not")
    println(newFile, "@SP")
    println(newFile, "A=M-1")
    println(newFile, "M=!M")

end

function HandleLabelCommand(c, fileName)
    println(newFile, "//label")
    println(newFile, "("*fileName*"."*c*")")
end

function HandleGotoCommand(c, fileName)
    println(newFile, "//goto")
    println(newFile, "@"*fileName*"."*c)
    println(newFile, "0;JMP")
end

function HandleIfGotoCommand(c, fileName)
    println(newFile, "//if-goto")
    println(newFile, "@SP")
    println(newFile, "M=M-1")
    println(newFile, "A=M")
    println(newFile, "D=M")
    println(newFile, "@"*fileName*"."*c)
    println(newFile, "D;JNE")
end


function HandleFunctionCommand(f, k)#push k locals
    println(newFile, "//function")
    println(newFile, "("*f*")")
    int_k=parse(Int64, k)
    for i in 1:int_k
        HandlePushCommand("constant", "0", "")
    end
end



function HandleCallCommand(g, n) #n=num of arguments
    println(newFile, "//call")
    global counterReturnAdress
    stringReturnAdress=string(counterReturnAdress)
    println(newFile, "@"*g*"."*"returnAdress"*stringReturnAdress) #push return adress
    println(newFile, "D=A")
    println(newFile, "@SP")
    println(newFile, "A=M")
    println(newFile, "M=D")
    println(newFile, "@SP")
    println(newFile, "M=M+1")
    println(newFile, "@LCL") #save local of the calling function
    println(newFile, "D=M")
    println(newFile, "@SP")
    println(newFile, "A=M")
    println(newFile, "M=D")
    println(newFile, "@SP")
    println(newFile, "M=M+1")
    println(newFile, "@ARG") #save arg of the calling function
    println(newFile, "D=M")
    println(newFile, "@SP")
    println(newFile, "A=M")
    println(newFile, "M=D")
    println(newFile, "@SP")
    println(newFile, "M=M+1")
    println(newFile, "@THIS") #save this of the calling function
    println(newFile, "D=M")
    println(newFile, "@SP")
    println(newFile, "A=M")
    println(newFile, "M=D")
    println(newFile, "@SP")
    println(newFile, "M=M+1")
    println(newFile, "@THAT") #save that of the calling function
    println(newFile, "D=M")
    println(newFile, "@SP")
    println(newFile, "A=M")
    println(newFile, "M=D")
    println(newFile, "@SP")
    println(newFile, "M=M+1")
    println(newFile, "@SP") #reposition argument
    println(newFile, "D=M")
    intNum=parse(Int64, n)
    intNum+=5
    stringNum=string(intNum)
    println(newFile, "@"*stringNum) # @new arg=n+5
    println(newFile, "D=D-A")
    println(newFile, "@ARG")
    println(newFile, "M=D")
    println(newFile, "@SP") #reposition local
    println(newFile, "D=M")
    println(newFile, "@LCL")
    println(newFile, "M=D") #LCL=SP
    println(newFile, "@"*g)
    println(newFile, "0;JMP")
    println(newFile, "("*g*"."*"returnAdress"*stringReturnAdress*")")
    counterReturnAdress+=1
end

function HandleReturnCommand()
    println(newFile, "//return")
    println(newFile, "@LCL") # FRAME=LCL
    println(newFile, "D=M")
    println(newFile, "@5") # RET=FRAME-5
    println(newFile, "A=D-A")
    println(newFile, "D=M")
    println(newFile, "@5") #save ret in temp
    println(newFile, "M=D")
    println(newFile, "@SP") # reposition the return value
    println(newFile, "M=M-1")
    println(newFile, "A=M")
    println(newFile, "D=M")
    println(newFile, "@ARG")
    println(newFile, "A=M")
    println(newFile, "M=D")

    println(newFile, "@ARG") #sp=arg+1
    println(newFile, "D=M")
    println(newFile, "@SP")
    println(newFile, "M=D+1")

    println(newFile, "@LCL") # THAT=LCL-1
    println(newFile, "M=M-1")
    println(newFile, "A=M")
    println(newFile, "D=M")
    println(newFile, "@THAT")
    println(newFile, "M=D")

    println(newFile, "@LCL") # THIS=LCL-2
    println(newFile, "M=M-1")
    println(newFile, "A=M")
    println(newFile, "D=M")
    println(newFile, "@THIS")
    println(newFile, "M=D")

    println(newFile, "@LCL") # ARG=LCL-3
    println(newFile, "M=M-1")
    println(newFile, "A=M")
    println(newFile, "D=M")
    println(newFile, "@ARG")
    println(newFile, "M=D")

    println(newFile, "@LCL") # restore lcl of the caller
    println(newFile, "M=M-1")
    println(newFile, "A=M")
    println(newFile, "D=M")
    println(newFile, "@LCL")
    println(newFile, "M=D")

    println(newFile, "@5")
    println(newFile, "A=M")
    println(newFile, "0;JMP")


end


function HandleInit()
    println(newFile, "@256")
    println(newFile, "D=A")
    println(newFile, "@SP")
    println(newFile, "M=D")
    HandleCallCommand("Sys.init", "0")
end







    global counterTrue=0
    global counterFalse=0
    global counterReturnAdress=1
    path=input()
    arr=split(path, "\\")
    newFile=open(path*"\\"*arr[end]*".asm", "w")
    if(arr[end]=="FibonacciElement" || arr[end]=="StaticsTest")
        HandleInit()
    end
    files=readdir(path)
    for file in files
        if endswith(file, ".vm")
            currentfile=open(path*'\\'*file, "r")
            for line in readlines(currentfile)
                if !(startswith(file, "//"))
                    words=split(line, " ")
                    if(words[1]=="push")
                        HandlePushCommand(words[2], words[3], file)
                    elseif(words[1]=="pop")
                        HandlePopCommand(words[2], words[3], file)
                    elseif(words[1]=="add")
                        HandleAddCommand()
                    elseif(words[1]=="sub")
                        HandleSubCommand()
                    elseif(words[1]=="neg")
                        HandleNegCommand()
                    elseif(words[1]=="eq")
                        HandleEqCommand()
                    elseif(words[1]=="lt")
                        HandleLtCommand()
                    elseif(words[1]=="gt")
                        HandleGtCommand()
                    elseif(words[1]=="and")
                        HandleAndCommand()
                    elseif(words[1]=="or")
                        HandleOrCommand()
                    elseif(words[1]=="not")
                        HandleNotCommand()
                    elseif(words[1]=="label")
                        HandleLabelCommand(words[2], arr[end])
                    elseif(words[1]=="goto")
                        HandleGotoCommand(words[2], arr[end])
                    elseif(words[1]=="if-goto")
                        HandleIfGotoCommand(words[2], arr[end])
                    elseif(words[1]=="function")
                        HandleFunctionCommand(words[2], words[3])
                    elseif(words[1]=="call")
                        HandleCallCommand(words[2], words[3])
                    elseif(words[1]=="return")
                        HandleReturnCommand()
                    end
                end
            end
            close(currentfile)
        end
    end
    close(newFile)
