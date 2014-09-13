@test_throws ErrorException documentation(Base)

for (file, contents) in pages(manual(documentation(Docile)))
    @test isfile(file)
    @test !isempty(contents)
end

for (file, contents) in pages(manual(documentation(Docile.Interface)))
    @test isfile(file)
    @test !isempty(contents)
end
