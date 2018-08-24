class ReportsController < ApplicationController
  def teacher_evaluation
    @staffs = Staff.where("status != #{Staff::INACTIVE}")

    render layout: false
  end

  def get_evaluation_term_courses
    staff = Staff.find(params[:staff_id])
    term_courses = staff.teacher_evaluations.to_a.uniq(&:term_course_id).map{|te| {term_course_id:te.term_course_id, term_course_name:"#{te.term_course.course.name} (#{te.term_course.term.code})"}}

    render json:term_courses
  end

  def download_teacher_evaluation
    staff = Staff.find(params[:staff_id])
    term_course = TermCourse.find(params[:term_course_id])
    staff_evaluations = staff.teacher_evaluations.where(term_course_id: term_course.id)
    evaluation_results = []
    Array(0..9).each  {|n| evaluation_results[n] = (staff_evaluations.to_a.sum(&:"question#{n+1}".to_sym).to_f / staff_evaluations.size).round(1) }

    Prawn::Document.new(background:"#{Rails.root.to_s}/private/hoja_membretada_reportes.png", :background_scale=>0.26, :margin=>[140,50,75,50] ) do |pdf|
      #pdf.number_pages "Página <page> de <total>", {:at=>[400, 680],:align=>:right,:size=>8}
      pdf.bounding_box([120, pdf.cursor + 80], :width => 450, :height => 100) do
        pdf.text"<b>CENTRO DE INVESTIGACIÓN EN MATERIALES AVANZADOS</b>", inline_format:true, size:13
        pdf.text"<b>Dirección Académica</b>", align: :left, inline_format:true, size:9
        pdf.move_down 20
        pdf.font_size 10
        pdf.text "<b>Reporte global del docente evaluado para el ciclo escolar: #{term_course.term.code} </b>", inline_format:true
        pdf.move_down 8
        pdf.text "<b>Materia: </b> #{term_course.course.name}", inline_format:true
        pdf.text "<b>Docente: </b> #{staff.full_name}", inline_format:true
        pdf.transparent(0) { pdf.stroke_bounds }
      end

      pdf.move_down 20
      pdf.font_size 9
      pdf.text "<b>Promedio global de la materia: #{(evaluation_results.inject(0.0) {|sum, val|sum + val } / evaluation_results.size).round(1)} de 5</b>", inline_format:true
      pdf.text "<b>Alumnos encuestados: #{staff_evaluations.size}</b>", inline_format:true
      pdf.text "<b>Fecha: </b>#{I18n.l(Date.today, format: '%A, %d de %B del %Y').capitalize}", inline_format:true
      pdf.move_down 20

      pdf.text "<b>Rúbricas</b>", inline_format: true, size: 11
      table_data = [['<b>Rúbrica</b>', '<b>Promedio</b>']]
      pdf.move_down 10
      pdf.table table_data, :position => :center, :cell_style => { align: :center, inline_format: true, border_width:0 }, :width => 500, column_widths:[400,100], header:true
      pdf.move_down 10
      table_data = [[]]
      #se obtienen las evaluaciones para el docente en esa materia
      Array(1..10).each {|n| table_data.push ["#{TeacherEvaluation::question_text(n)}",Prawn::Table::Cell::Text.new( pdf, [0,0], content: "#{evaluation_results[n-1]}", align: :center)]}
      pdf.table(table_data,:width => 500, column_widths:[400,100], cell_style:{border_width:0}, row_colors: ["fdfdfd", "f2f2f2"])
      pdf.move_down 20

      pdf.text "<b>Comentarios de los alumnos</b>", size: 11, inline_format: true
      pdf.move_down 10

      staff_evaluations.each{|evaluation| pdf.text "-#{evaluation.notes}\n\n" if !evaluation.notes.blank?}

      pdf.number_pages 'Página <page> de <total>',  at: [pdf.bounds.right - 100, -20], align: :right

      send_data pdf.render, filename: "Eval-#{staff.full_name.gsub(' ','-')}", type: "application/pdf", disposition: "inline"
    end
  end
end
