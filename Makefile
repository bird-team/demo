all: article

article: install article.pdf article.md article.docx

article.docx: article.Rmd
	docker run --name=brisbanebird -dt 'brisbanebirdteam/docker:latest' \
	&& docker cp . brisbanebird:/tmp/ \
	&& docker exec brisbanebird sh -c "R -e \"rmarkdown::render('/tmp/article.Rmd', output_format = 'word_document', clean = TRUE)\"" \
	&& docker cp brisbanebird:/tmp/article.docx . || true
	docker stop brisbanebird || true && docker rm brisbanebird || true

article.pdf: article.Rmd
	@docker run --name=brisbanebird -dt 'brisbanebirdteam/docker:latest' \
	&& docker cp . brisbanebird:/tmp/ \
	&& docker exec brisbanebird sh -c "R -e \"rmarkdown::render('/tmp/article.Rmd', output_format = 'pdf_document', clean = TRUE)\"" \
	&& docker cp brisbanebird:/tmp/article.pdf . || true
	@docker stop brisbanebird || true && docker rm brisbanebird || true

article.md: article.Rmd
	docker run --name=brisbanebird -dt 'brisbanebirdteam/docker:latest' \
	&& docker cp . brisbanebird:/tmp/ \
	&& docker exec brisbanebird sh -c "R -e \"rmarkdown::render('/tmp/article.Rmd', output_format = 'github_document', clean = TRUE, output_options = list(html_preview = FALSE))\"" \
	&& docker cp brisbanebird:/tmp/article.md . || true
	docker stop brisbanebird || true && docker rm brisbanebird || true

install:
	docker pull brisbanebirdteam/docker:latest

clean:
	@rm -f article.pdf
	@rm -f article.md
	@rm -f article.docx
	@rm -f article.log
	@rm -f article.tex
	@rm -f article.aux
	@rm -f article.fls
	@rm -f article.out
	@rm -f article.fdb_latexmk
	@rm -rf article_files
	@docker stop brisbanebird || true && docker rm brisbanebird || true

.PHONY: all clean article install
