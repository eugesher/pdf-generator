import * as fs from 'fs';
import * as htmlPdf from 'html-pdf';
import { CreateOptions } from 'html-pdf';
import * as path from 'path';
import { Injectable } from '@nestjs/common';
import { CreateJobAppicationPdfDto } from './dto/create-job-appication-pdf.dto';
import { NextFunction, Request, Response } from 'express';
import { getCurrentDate } from '../utils/functions';

@Injectable()
export class PdfService {
  create(
    dto: CreateJobAppicationPdfDto,
    req: Request,
    res: Response,
    next: NextFunction,
  ) {
    console.log(req.body);

    const candidateName = `${dto.lastName} ${dto.firstName} ${dto.patronymic}`;
    const careerObjective = dto.careerObjective;
    const signatureDescription = `${dto.lastName} ${dto.firstName[0]}.${dto.patronymic[0]}.`;
    const today = getCurrentDate();

    const options: CreateOptions = {
      format: 'A4',
      orientation: 'portrait',
      type: 'pdf',
      quality: '100',
    };

    const htmlDocument = fs
      .readFileSync(
        path.join(__dirname, '../../public/job-application.html'),
        'utf-8',
      )
      .replace('{{candidateName}}', candidateName)
      .replace('{{careerObjective}}', careerObjective)
      .replace('{{signatureDescription}}', signatureDescription)
      .replace('{{today}}', today);

    const pdf = htmlPdf.create(htmlDocument, options);

    return pdf.toStream((err, stream: fs.ReadStream): void => {
      if (err) next(err);
      stream.pipe(res);
    });
  }
}
