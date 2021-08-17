import {
  Controller,
  Post,
  Body,
  HttpCode,
  Header,
  Res,
  Next,
} from '@nestjs/common';
import { PdfService } from './pdf.service';
import { CreateJobAppicationPdfDto } from './dto/create-job-appication-pdf.dto';
import { NextFunction, Response } from 'express';

@Controller('pdf')
export class PdfController {
  constructor(private readonly pdfService: PdfService) {}

  @HttpCode(200)
  @Post()
  @Header('Content-Type', 'application/pdf')
  @Header('Content-Disposition', 'attachment; filename=job-application')
  create(
    @Body() dto: CreateJobAppicationPdfDto,
    @Res() res: Response,
    @Next() next: NextFunction,
  ) {
    return this.pdfService.create(dto, res, next);
  }
}
