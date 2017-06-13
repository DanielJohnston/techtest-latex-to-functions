# This should not need to happen, presumably getting required
require './app'

describe String do
  describe '#objectify' do
    context 'addition' do
      it 'objectifies -2+3' do
        input = '-2+3'
        expected_output = add(-2, 3)
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies -24+a' do
        input = '-24+a'
        expected_output = add(-24, 'a')
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies a+b+c+d+355' do
        input = 'a+b+c+d+355'
        expected_output = add('a', 'b', 'c', 'd', 355)
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies -2-25' do
        input = '-2-25'
        expected_output = add(-2, -25)
        expect(input.objectify).to eq expected_output
      end
    end

    context 'multiplication' do
      it 'objectifies 2x' do
        input = '2x'
        expected_output = mtp(2, 'x')
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies -2ay' do
        input = '-2ay'
        expected_output = mtp(-2, 'a', 'y')
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies -a' do
        input = '-a'
        expected_output = mtp(-1, 'a')
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies uz24j78k9' do
        input = 'uz24j78k9'
        expected_output = mtp('u', 'z', 24, 'j', 78, 'k', 9)
        expect(input.objectify).to eq expected_output
      end
    end

    context 'division' do
      it 'objectifies \frac{-14}{25}' do
        input = '\frac{-14}{25}'
        expected_output = div(-14, 25)
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies \frac{a}{d}' do
        input = '\frac{a}{d}'
        expected_output = div('a', 'd')
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies \frac{x}{-25}' do
        input = '\frac{x}{-25}'
        expected_output = div('x', -25)
        expect(input.objectify).to eq expected_output
      end
    end

    context 'mixed stack lvl 2' do
      it 'objectifies \frac{-14a}{2+x}' do
        input = '\frac{-14a}{2+x}'
        expected_output = div(mtp(-14,'a'),add(2,'x'))
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies \frac{a+2}{-d}' do
        input = '\frac{a+2}{-d}'
        expected_output = div(add('a', 2), mtp(-1, 'd'))
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies 3(x+7)+4' do
        input = '3(x+7)+4'
        expected_output = add(mtp(3,add('x', 7)), 4)
        expect(input.objectify).to eq expected_output
      end
    end

    context 'mixed stack lvl 3' do
      it 'objectifies 2(x+\frac{3}{y})w' do
        input = '2(x+\frac{3}{y})w'
        expected_output = mtp(2,add('x',div(3,'y')),'w')
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies \frac{21a+3}{\frac{-14a}{2+x}-(b+d)}' do
        input = '\frac{21a+3}{\frac{-14a}{2+x}-(b+d)}'
        expected_output = div(add(mtp(21,'a'),3),add(div(mtp(-14,'a'),add(2,
          'x')),mtp(-1,add('b','d'))))
        expect(input.objectify).to eq expected_output
      end
    end

    context 'can handle insane stacks' do
      it 'objectifies \frac{21a+3}{4-(2(x+\frac{3}{y})w+d)}' do
        input = '\frac{21a+3}{4-(2(x+\frac{3}{y})w+d)}'
        expected_output = div(add(mtp(21,'a'),3),add(4,mtp(-1,
          add(mtp(2,add('x',div(3,'y')),'w'),'d'))))
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies \frac{21a+3}{\frac{-14a}{2(x+\frac{3}{y})w+x}-(b+d)}' do
        input = '\frac{21a+3}{\frac{-14a}{2(x+\frac{3}{y})w+x}-(b+d)}'
        expected_output = div(add(mtp(21,'a'),3),add(div(mtp(-14,'a'),add(mtp(2,
          add('x',div(3,'y')),'w'),'x')),mtp(-1,add('b','d'))))
        expect(input.objectify).to eq expected_output
      end
    end

    context 'power' do
      it 'objectifies x^2' do
        input = 'x^2'
        expected_output = pow('x', 2)
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies (2x)^34' do
        input = '(2x)^34'
        expected_output = mtp(pow(mtp(2, 'x'), 3),4)  #this is intended as LaTeX
        # interprets the string in the same way.
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies (2x)^{34}' do
        input = '(2x)^{34}'
        expected_output = pow(mtp(2, 'x'), 34)
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies x^{1+1}' do
        input = 'x^{2+y}'
        expected_output = pow('x', add(2, 'y'))
        expect(input.objectify).to eq expected_output
      end

      it 'objectifies (a^{2+x})^4' do
        input = '(a^{2+x})^4'
        expected_output = pow(pow('a',add(2,'x')),4)
        expect(input.objectify).to eq expected_output
      end

      it 'objectify some monstrocity with powers' do
        input = '(3(x+\frac{3\frac{3}{x}+5}{4+5+a})+4)^{2(x+\frac{3}{y})w}'
        expected_output = pow(add(mtp(3,add('x',div(add(mtp(3,div(3,'x')),5),
          add(4,5,'a')))),4),mtp(2,add('x',div(3,'y')),'w'))
        expect(input.objectify).to eq expected_output
      end
    end
  end
end
