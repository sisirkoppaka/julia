module TestEnums

using Base.Test

@test_throws MethodError convert(Base.Enums.Enum, 1.0)

Base.Enums.@enum Fruit apple orange kiwi
@test typeof(Fruit) == DataType
@test isbits(Fruit)
@test typeof(apple) <: Fruit <: Base.Enums.Enum
@test typeof(apple.n) <: Int
@test int(apple) == 0
@test int(orange) == 1
@test int(kiwi) == 2
@test Fruit(0) == apple
@test Fruit(1) == orange
@test Fruit(2) == kiwi
@test_throws ErrorException Fruit(3)
@test_throws ErrorException Fruit(-1)
@test Fruit(Val{0}) == apple
@test_throws ErrorException Fruit(Val{3})
@test Fruit(0x00) == apple
@test Fruit(big(0)) == apple
@test_throws MethodError Fruit(0.0)
@test start(Fruit) == 1
@test next(Fruit,1) == (apple,2)
@test next(Fruit,2) == (orange,3)
@test next(Fruit,3) == (kiwi,4)
@test !done(Fruit,3)
@test done(Fruit,4)
@test length(Fruit) == 3
@test typemin(Fruit) == apple
@test typemax(Fruit) == kiwi
@test convert(Fruit,0) == apple
@test convert(Fruit,1) == orange
@test convert(Fruit,2) == kiwi
@test_throws InexactError convert(Fruit,3)
@test_throws InexactError convert(Fruit,-1)
@test convert(UInt8,apple) === 0x00
@test convert(UInt16,orange) === 0x0001
@test convert(UInt128,kiwi) === 0x00000000000000000000000000000002
@test typeof(convert(BigInt,apple)) <: BigInt
@test convert(BigInt,apple) == 0
@test convert(Bool,apple) == false
@test convert(Bool,orange) == true
@test_throws InexactError convert(Bool,kiwi)
@test names(Fruit) == [apple, orange, kiwi]

f(x::Fruit) = "hey, I'm a Fruit"
@test f(apple) == "hey, I'm a Fruit"

d = Dict(apple=>"apple",orange=>"orange",kiwi=>"kiwi")
@test d[apple] == "apple"
@test d[orange] == "orange"
@test d[kiwi] == "kiwi"
vals = [apple,orange,kiwi]
for (i,enum) in enumerate(Fruit)
    @test enum == vals[i]
end

Base.Enums.@enum(QualityofFrenchFood, ReallyGood)
@test length(QualityofFrenchFood) == 1
@test typeof(ReallyGood) <: QualityofFrenchFood <: Base.Enums.Enum
@test int(ReallyGood) == 0

Base.Enums.@enum Binary _zero=0 _one=1 _two=10 _three=11
@test _zero.n === 0
@test _one.n === 1
@test _two.n === 10
@test _three.n === 11
Base.Enums.@enum Negative _neg1=-1 _neg2=-2
@test _neg1.n === -1
@test _neg2.n === -2
Base.Enums.@enum Negative2 _neg5=-5 _neg4 _neg3
@test _neg5.n === -5
@test _neg4.n === -4
@test _neg3.n === -3

# currently allow silent overflow
Base.Enums.@enum Uint8Overflow ff=0xff overflowed
@test ff.n === 0xff
@test overflowed.n === 0x00

@test_throws MethodError eval(macroexpand(:(Base.Enums.@enum Test1 _zerofp=0.0)))

@test_throws InexactError eval(macroexpand(:(Base.Enums.@enum Test11 _zerofp2=0.5)))
# can't use non-identifiers as enum members
@test_throws ErrorException eval(macroexpand(:(Base.Enums.@enum Test2 1=2)))
# other Integer types of enum members
Base.Enums.@enum Test3 _one_Test3=0x01 _two_Test3=0x02 _three_Test3=0x03
@test typeof(_one_Test3.n) <: UInt8
@test _one_Test3.n === 0x01
@test length(Test3) == 3

Base.Enums.@enum Test4 _one_Test4=0x01 _two_Test4=0x0002 _three_Test4=0x03
@test typeof(_one_Test4.n) <: UInt16

Base.Enums.@enum Test5 _one_Test5=0x01 _two_Test5=0x00000002 _three_Test5=0x00000003
@test typeof(_one_Test5.n) <: UInt32

Base.Enums.@enum Test6 _one_Test6=0x00000000000000000000000000000001 _two_Test6=0x00000000000000000000000000000002
@test typeof(_one_Test6.n) <: UInt128

Base.Enums.@enum Test7 _zero_Test7=0b0 _one_Test7=0b1 _two_Test7=0b10
@test typeof(_zero_Test7.n) <: UInt8

@test_throws MethodError eval(macroexpand(:(Base.Enums.@enum Test8 _zero="zero")))
@test_throws MethodError eval(macroexpand(:(Base.Enums.@enum Test9 _zero='0')))

Base.Enums.@enum Test8 _zero_Test8=zero(Int64)
@test typeof(_zero_Test8.n) <: Int64
@test _zero_Test8.n === Int64(0)

Base.Enums.@enum Test9 _zero_Test9 _one_Test9=0x01 _two_Test9
@test typeof(_zero_Test9.n) <: Int
@test _zero_Test9.n === 0
@test typeof(_one_Test9.n) <: Int
@test _one_Test9.n === 1
@test typeof(_two_Test9.n) <: Int
@test _two_Test9.n === 2

Base.Enums.@enum Test10 _zero_Test10=0x00 _one_Test10 _two_Test10
@test typeof(_zero_Test10.n) <: UInt8
@test _zero_Test10.n === 0x00
@test typeof(_one_Test10.n) <: UInt8
@test _one_Test10.n === 0x01
@test typeof(_two_Test10.n) <: UInt8
@test _two_Test10.n === 0x02

end # module