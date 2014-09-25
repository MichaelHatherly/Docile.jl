@test_throws ErrorException documentation(Base)

for p in pages(manual(documentation(Docile)))
    @test isfile(file(p))
    @test !isempty(data(docs(p)))
end

for p in pages(manual(documentation(Docile.Interface)))
    @test isfile(file(p))
    @test !isempty(data(docs(p)))
end
