import 'dart:developer';

class DynamicTranslations{
  static Map<String,String> order = {
    'Ascendente':'Ascendant',
    'Descendente':'Descendant',
    'Juros de mora':'Late fees',
    'Valor a pagar':'Amount to pay',
    'Data limite de pagamento':'Payment deadline'
  };
  static Map<String,String> filter = {
    'Despesas não saldadas':'Unpaid expenses',
    'Certidão':'Certificate',
    'Propinas':'Tuition fees',
    'Repetição de exame para melhoria de classificação':'Exam retake for grade improvement',
    'Seguro Escolar':'School insurance',
    'Serviços':'Services',
    'Multas da biblioteca':'Library late fees',
    'Juros de mora propinas':'Tuition late fees'
  };

  static String getOrderTranslation(String param, String language){
    if(language == 'pt'){
      return param;
    }
    else{
      final String paramEn = order[param];
      if (paramEn == null){
        log('WARNING: String ' + param + ' is not available in any language other then portuguese!\n Defaulting to portuguese.');
        return param;
      }else{
        return paramEn;
      }
    }
  }

  static String getFilterTranslation(String param, String language){
    if(language == 'pt'){
      return param;
    }
    else{
      final String paramEn = filter[param];
      if (paramEn == null){
        log('WARNING: String ' + param + ' is not available in any language other then portuguese!\n Defaulting to portuguese.');
        return param;
      }else{
        return paramEn;
      }
    }
  }

}