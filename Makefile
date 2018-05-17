all: article

article: article.pdf article.md article.docx

article.docx: install article.Rmd
	 docker run --name=brisbanebird --rm -v $(pwd):/tmp 'brisbanebirdteam/docker:latest' sh -c "R -e \"rmarkdown::render('/tmp/article.Rmd', output_format = 'word_document', clean = TRUE)\""

article.pdf: install article.Rmd
	 docker run --name=brisbanebird --rm -v $(pwd):/tmp 'brisbanebirdteam/docker:latest' sh -c "R -e \"rmarkdown::render('/tmp/article.Rmd', output_format = 'pdf_document', clean = TRUE)\""

article.md: install article.Rmd
	 docker run --name=brisbanebird --rm -v $(pwd):/tmp 'brisbanebirdteam/docker:latest' sh -c "R -e \"rmarkdown::render('/tmp/article.Rmd', output_format = 'github_document', clean = TRUE)\""
	 rm -rf

install:
	docker pull brisbanebirdteam/docker:latest

clean:
	rm -f article.pdf
	rm -f article.md
	rm -f article.docx
	rm -rf article_files

.PHONY: all clean article install
