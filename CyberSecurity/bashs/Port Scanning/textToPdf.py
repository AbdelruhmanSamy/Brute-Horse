from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle

def generate_pdf(input_txt_file, output_pdf_file):
    # Open the text file and read its contents
    with open(input_txt_file, 'r') as file:
        lines = file.readlines()

    # Create a PDF document using SimpleDocTemplate
    pdf = SimpleDocTemplate(output_pdf_file, pagesize=A4)

    # Styles for the PDF
    styles = getSampleStyleSheet()
    story = []

    # Title (Heading)
    story.append(Paragraph("Penetration Test Report", styles['Title']))
    story.append(Spacer(1, 0.2 * inch))

    # Add content from the text file with a template style
    for line in lines:
        # Add each line from the .txt file as a paragraph
        story.append(Paragraph(line.strip(), styles['BodyText']))
        story.append(Spacer(1, 0.1 * inch))

    # Generate the PDF
    pdf.build(story)

# Example usage
generate_pdf(".//scan_results//scan_report.txt", ".//scan_results//scan_report.pdf")
