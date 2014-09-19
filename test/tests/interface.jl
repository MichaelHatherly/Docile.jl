@test_throws ErrorException documentation(Base)

for (file, page) in pages(manual(documentation(Docile)))
    @test isfile(file)
    @test !isempty(page)
end

for (file, page) in pages(manual(documentation(Docile.Interface)))
    @test isfile(file)
    @test !isempty(page)
end
