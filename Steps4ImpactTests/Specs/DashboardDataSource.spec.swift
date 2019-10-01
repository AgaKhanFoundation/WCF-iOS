/**
 * Copyright © 2019 Aga Khan Foundation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 **/

import Foundation
import Quick
import Nimble
@testable import Steps4Impact

class DashboardDataSourceSpec: QuickSpec {
  override func spec() {
    var akfCausesService: AKFCausesServiceMock!
    var facebookService: FacebookServiceMock!
    var userInfoService: UserInfoServiceMock!
    var dataSource: DashboardDataSource!

    beforeEach {
      akfCausesService = AKFCausesServiceMock()
      facebookService = FacebookServiceMock()
      userInfoService = UserInfoServiceMock()
      dataSource = DashboardDataSource()
      dataSource.akfCausesService = akfCausesService
      dataSource.faceboookService = facebookService
      dataSource.userInfoService = userInfoService
    }

    describe("DashboardDataSource") {
      it("should init correctly") {
        expect(dataSource.cells.count) == 0
      }

      context("without network activity") {
        context("if no pedometer is set") {
          it("should have the correct cells") {
            dataSource.configure()
            expect(dataSource.cells[0].count) == 4
            expect(dataSource.cells[0][0]).to(beAKindOf(ProfileCardCellContext.self))
            expect(dataSource.cells[0][1]).to(beAKindOf(EmptyActivityCellContext.self))
            expect(dataSource.cells[0][2]).to(beAKindOf(InfoCellContext.self))
            expect(dataSource.cells[0][3]).to(beAKindOf(DisclosureCellContext.self))
          }
        }

        context("if pedometer is set") {
          it("should have the correct cells") {
            userInfoService.pedometerSource = .healthKit
            dataSource.configure()
            expect(dataSource.cells[0].count) == 4
            expect(dataSource.cells[0][1]).to(beAKindOf(InfoCellContext.self))
          }
        }
      }
      // TODO(sami.suteria) add support for async tests
    }
  }
}
